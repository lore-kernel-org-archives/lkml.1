Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbYLFKqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbYLFKqz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 05:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYLFKqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 05:46:45 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:43683 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYLFKqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 05:46:44 -0500
Date: Sat, 6 Dec 2008 16:09:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jay Lan <jlan@sgi.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] introduce get_mm_hiwater_xxx(), fix
	taskstats->hiwater_xxx accounting
Message-ID: <20081206103904.GC24782@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Hugh Dickins <hugh@veritas.com>, Jay Lan <jlan@sgi.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
	Jonathan Lim <jlim@sgi.com>
References: <20081203181220.GA22918@redhat.com> <Pine.LNX.4.64.0812031957570.19174@blonde.anvils> <20081204135250.GA5448@redhat.com> <Pine.LNX.4.64.0812051216020.10157@blonde.anvils> <493975BE.60202@sgi.com> <20081206084223.GA24782@balbir.in.ibm.com> <Pine.LNX.4.64.0812060950120.22390@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812060950120.22390@blonde.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hugh Dickins <hugh@veritas.com> [2008-12-06 09:56:19]:

> On Sat, 6 Dec 2008, Balbir Singh wrote:
> > 
> > Yes, true and getdelays can display all the exported information.
> > 
> > The race does seem concerning, I would vote for keeping the update in
> > there and disabling preemption around the update, so that hiwater
> > cannot swing back and forth.
> 
> ??  Oleg is _fixing_ a race by removing the update from do_exit();
> and he is fixing the way the hiwater info was collected in tsacct.c.

I see that change and the reasoning seems accurate that we can query
the task at anytime, but I worry that if taskstats is not enabled, we'll
never call update_hiwater.* on the exiting task. 

I wonder if a thread came in and like Oleg said, did (without taskstats
enabled)

free(malloc(some size)), followed by exit()

whether task_mem() would show the correct results for hiwater.*. I
should try it out and look more closely at the code as well.

-- 
	Balbir
