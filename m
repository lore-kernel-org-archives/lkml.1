Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbYA0XgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbYA0XgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 18:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYA0XgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 18:36:00 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:34508 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYA0Xf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 18:35:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ALFVL+ojOEnerUYtCQfQOwUkMP9Ro8IQxhDOjU/H1obAbbYkhc+mtMnjPZ5cBkB2G0hNr81EzDwWqCwvH2LDTlu5alBAfrmZJd/oKTjUiRqSATDjGxBsoZ7i0klsa8ZuJKJb/trA8F5Kx4cqSmPiQvdy+MwvP4jAWCDBMha9ruU=
Date: Sun, 27 Jan 2008 19:35:55 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: X fails to start with latest Linus git
Message-Id: <20080127193555.2d1370ad.kjwinchester@gmail.com>
In-Reply-To: <20080127124244.GA24999@elte.hu>
References: <479BCE03.6070603@gmail.com>
	<479BD1D1.8020503@gmail.com>
	<20080127062703.GA23444@elte.hu>
	<20080127083129.c14452ca.kjwinchester@gmail.com>
	<20080127123702.GB21282@elte.hu>
	<20080127124120.GA23377@elte.hu>
	<20080127124244.GA24999@elte.hu>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2008 13:42:44 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > hm, perhaps it's due to the xtime lock dependency:
> > 
> >         do {
> >                 seq = read_seqbegin(&xtime_lock);
> >                 getnstimeofday(ts);
> >                 tomono = wall_to_monotonic;
> > 
> >         } while (read_seqretry(&xtime_lock, seq));
> > 
> > perhaps your system somehow generates a printk from within an 
> > xtime_lock locked section?
> 
> i _bet_ it's these printks that cause your lockup:
> 
>  [   10.313437] Marking TSC unstable due to: cpufreq changes.
>  [   10.313437] Time: hpet clocksource has been installed.
>  [   10.424431] Clocksource tsc unstable (delta = -121609771 ns)
> 
> as these are done with the xtime lock held.
> 

Yes, disabling cpufreq (in my .config since, sadly, there is no command
line option to disable it) fixes the problem.

-- 
Kevin Winchester <kjwinchester@gmail.com>
