Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbXKTIQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbXKTIQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 03:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbXKTIQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 03:16:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53643 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364AbXKTIQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 03:16:45 -0500
Date: Tue, 20 Nov 2007 00:16:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Scott James Remnant <scott@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] wait_task_stopped: pass correct exit_code to
 wait_noreap_copyout
Message-Id: <20071120001624.83c7fbce.akpm@linux-foundation.org>
In-Reply-To: <1195545322.14510.170.camel@wing-commander>
References: <1195377204.6070.3.camel@wing-commander>
	<20071119224326.198f77a0.akpm@linux-foundation.org>
	<1195545322.14510.170.camel@wing-commander>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 07:55:22 +0000 Scott James Remnant <scott@ubuntu.com> wrote:

> On Mon, 2007-11-19 at 22:43 -0800, Andrew Morton wrote:
> > On Sun, 18 Nov 2007 09:13:24 +0000 Scott James Remnant <scott@ubuntu.com> wrote:
> > 
> > > In wait_task_stopped() exit_code already contains the right value for
> > > the si_status member of siginfo, and this is simply set in the non
> > > WNOWAIT case.
> > >     
> > > Pass it unchanged to wait_noreap_copyout();  we would only need to
> > > shift it and add 0x7f if we were returning it in the user status field
> > > and that isn't used for any function that permits WNOWAIT.
> > >     
> > Is this bug visible to userspace?  If so, I'm surprised that none of the
> > various testsuites (which like to exercise this sort of interface) has
> > detected it.
> > 
> Absolutely;  if you call waitid() with a stopped or traced process,
> you'll get the signal in siginfo.si_status as expected -- however if you
> call waitid(WNOWAIT) at the same time, you'll get the signal << 8 | 0x7f
> 

hm, OK.  Well I guess I'll stick a for-2.6.23 tag on this as well as
queueing it for 2.6.24.

