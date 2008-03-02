Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbYCBUJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbYCBUJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbYCBUJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:09:04 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:22371 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbYCBUJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:09:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=eyN++PQXQ19To0IPEyriDTrAETWpcuX0o32KFMuotewFrLvHwG4mA42ZyBtkZOxFMc4NmWB6Z7E7MtPDkiuyr8K8HdudExLrBwYKLOMAvTZuz7Rg6S9VOOIUq9HW87F4q/GoRWIpg+x31lSENwAkDZPOqXf/MSRRTkIZ875yNrc=
Date: Sun, 2 Mar 2008 21:08:05 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc: complete lockup on boot/start of X (bisected)
Message-ID: <20080302200801.GA6184@joi>
References: <20080302185935.GA6100@joi> <20080302120010.79d19405@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080302120010.79d19405@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 02, 2008 at 12:00:10PM -0800, Arjan van de Ven wrote:
> On Sun, 2 Mar 2008 20:00:05 +0100
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > Hi
> > Since early 2.6.25 days I'm having strange lockup on boot. As it
> > happens rarely (in ~10% of boots), I couldn't bisect it. No kernel
> > panic, SysRq didn't work, so I couldn't provide any useful
> > informations to LK community. I hoped someone else would fix it... :)
> > 
> > It's rc3 so I decided to narrow it down myself. I enabled netconsole 
> > to see whether some other informations are printed before lockup.
> > It didn't help, but I noticed that lockup happens much more
> > frequenly! (~50%) So I bisected it down to:
> > 
> > 8f4d37ec073c17e2d4aa8851df5837d798606d6f is first bad commit
> > commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Fri Jan 25 21:08:29 2008 +0100
> > 
> >     sched: high-res preemption tick
> > 
> >     Use HR-timers (when available) to deliver an accurate preemption
> > tick.
> 
> 
> the only unusual/suspect thing you have is nvidiafb driver; that's not very commonly used.
> Can you do a quick try with that thing disabled? Maybe it has some races that are more likely
> to trigger after this patch...
I switched from vesa to nvidiafb few days ago. Lockup started to happen earlier.

Marcin
