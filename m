Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbYC2KwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbYC2KwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 06:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbYC2KwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 06:52:13 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:43325 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbYC2KwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 06:52:12 -0400
Date: Sat, 29 Mar 2008 13:51:12 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 4/5] don't panic if /sbin/init exits or killed
Message-ID: <20080329105112.GC359@tv-sign.ru>
References: <20080316155453.GA20845@tv-sign.ru> <47EDD80C.6030507@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EDD80C.6030507@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28, H. Peter Anvin wrote:
>
> Oleg Nesterov wrote:
> >If the buggy init exits, the kernel panics. I see no point for this. It is 
> >very
> >possible that the system is still usable enough, at least to read the logs 
> >and
> >prepare the bug report.
> >
> >Change exit_child_reaper() to do BUG() instead of panic().
> >
> >Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
> This would be highly undesirable in a production system, since it would 
> leave the machine an unusable zombie.  In a production system, the panic 
> can be made to reboot the system, bringing it back online.

I can't agree. Following this logic, we should always use panic() instead
of BUG().

I think the system should try to use any chance to survive, and we have
panic_on_oops.


That said, Stephen has a good reason to nack this patch. But still I hope
it is possible to find a simple solution. Not that I think this is really
important, but this panic() is silly, imho.

Oleg.

