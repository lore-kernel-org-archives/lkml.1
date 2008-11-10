Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbYKJCw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbYKJCw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 21:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYKJCws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 21:52:48 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:54179 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYKJCwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 21:52:47 -0500
Date: Sun, 9 Nov 2008 20:52:45 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 06/11] Common functions for
	TOMOYOLinux.
Message-ID: <20081110025245.GA28174@us.ibm.com>
References: <20081104060847.086543472@nttdata.co.jp> <20081104060951.618445959@nttdata.co.jp> <20081105151221.d605226f.akpm@linux-foundation.org> <200811090138.GBG65138.FVOHOJOtMLQFFS@I-love.SAKURA.ne.jp> <20081110004131.GA25021@us.ibm.com> <200811100224.mAA2ORgv096549@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811100224.mAA2ORgv096549@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> Hello.
> 
> Serge E. Hallyn wrote:
> > > There are two PIDs, PID seen from inside virtualized environment and
> > > PID seen from outside virtualized environment. To clarify, let me call
> > > the former "PIDv" and the latter "PIDg".
> > > 
> > > PIDv is not system-wide unique. But PIDg is system-wide unique, aren't they?
> > > The PID received from outside virtualized environment is PIDg and they are
> > > system-wide unique, am I right?
> > 
> > You are doing find_task_by_vpid(), so you are not looking up a task by
> > global pid.
> > 
> I need to clarify reachability of "struct task_struct".
> 
> A process inside a virtualized environment cannot reach "struct task_struct"
> which belongs to outside the virtualized environment.
> 
> A process outside virtualized environments can reach "struct task_struct"
> which belongs to inside virtualized environments, can't it?

To be precise, there isn't a real 'inside' and 'outside' virtualized
environements.  Rather pid namespaces are hierarchical.

(Taking another look) it looks like In is_select_one() you're doing the
right thing - you look up the domain of a task based on
find_task_by_vpid() on a passed-in pid.  Seems correct.

thanks,
-serge
