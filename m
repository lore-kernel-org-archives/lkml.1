Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYLGRkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYLGRkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYLGRkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:40:05 -0500
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:45384 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbYLGRkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:40:02 -0500
Date: Sun, 7 Dec 2008 23:09:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>, Jay Lan <jlan@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
       Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] introduce get_mm_hiwater_xxx(), fix
	taskstats->hiwater_xxx accounting
Message-ID: <20081207173958.GC13333@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Oleg Nesterov <oleg@redhat.com>,
	Hugh Dickins <hugh@veritas.com>, Jay Lan <jlan@sgi.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jiri Pirko <jpirko@redhat.com>, linux-kernel@vger.kernel.org,
	Jonathan Lim <jlim@sgi.com>
References: <Pine.LNX.4.64.0812031957570.19174@blonde.anvils> <20081204135250.GA5448@redhat.com> <Pine.LNX.4.64.0812051216020.10157@blonde.anvils> <493975BE.60202@sgi.com> <20081206084223.GA24782@balbir.in.ibm.com> <Pine.LNX.4.64.0812060950120.22390@blonde.anvils> <20081206103904.GC24782@balbir.in.ibm.com> <20081207161750.GA25966@redhat.com> <20081207165828.GA13333@balbir.in.ibm.com> <20081207172845.GA28520@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081207172845.GA28520@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2008-12-07 18:28:45]:

[snip]

> No. When the task does unmap, vm does update_hiwater_vm() "internally",
> it does not need the help from do_exit(). And do_exit() can't help,
> it is to late to calculate the maximum, ->total_vm was already decreased.
> 
> do_exit() itself does not affect rss/vm. Until we call exit_mmap(),
> but at this point ->mm is dead, nobody can look at it, its ->mm_users
> is zero.
>

OK, I think that makes sense, since free would have cleaned up the
memory before entering the exit system call.

[snip] 

-- 
	Balbir
