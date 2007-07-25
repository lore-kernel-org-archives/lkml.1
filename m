Return-Path: <linux-kernel-owner+w=401wt.eu-S1764735AbXGYH4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764735AbXGYH4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbXGYH4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:56:40 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:10443 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbXGYH4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VguncO/iUvYpD+faFF4H7baZlVH/bSfqcqpX0PuOnWWpElKgOYurYyXl3xOm7HEG4xKg11WKjl+g/Q3VPsED2PcRaR+bbEnDh4wjgiQ66tUpYF6b3/ZMaqGkBHZUYhTlio2Lnj92ew70gVzBKEL61AfVGN3IcEm555aZfaVraDE=
Message-ID: <e9f486400707250056i7f6ef2aducef8c0f7cf11c09c@mail.gmail.com>
Date: Wed, 25 Jul 2007 09:56:38 +0200
From: "Henri Hunnekens" <henrihunnekens@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: TSC calibration sometimes not correct with RT patch.
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070725073949.GB595@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e9f486400707250025k163d34cdk97cf2722db739634@mail.gmail.com>
	 <20070725073949.GB595@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some more information, the problems occurs on a SMP machine. I've
added the system logging which displays the CPU speed. The last line
shows an inaccurate processor speed! I'll try an update, but I expect
this has something to do with the TSC calibration and that hasn't
changed, If I'm correct.

Jul 23 07:50:53 localhost kernel: Detected 1795.663 MHz processor.
Jul 23 08:07:35 localhost kernel: Detected 1795.707 MHz processor.
Jul 23 08:27:44 localhost kernel: Detected 1795.623 MHz processor.
Jul 23 08:36:56 localhost kernel: Detected 1795.599 MHz processor.
Jul 23 08:43:36 localhost kernel: Detected 1795.641 MHz processor.
Jul 23 08:55:12 localhost kernel: Detected 1795.587 MHz processor.
Jul 23 09:13:26 localhost kernel: Detected 1795.625 MHz processor.
Jul 23 09:38:31 localhost kernel: Detected 1795.573 MHz processor.
Jul 23 09:54:39 localhost kernel: Detected 1795.662 MHz processor.
Jul 23 10:01:57 localhost kernel: Detected 1795.645 MHz processor.
Jul 23 10:22:18 localhost kernel: Detected 1795.648 MHz processor.
Jul 23 10:55:43 localhost kernel: Detected 1795.582 MHz processor.
Jul 23 11:00:29 localhost kernel: Detected 1795.589 MHz processor.
Jul 23 11:08:32 localhost kernel: Detected 1795.632 MHz processor.
Jul 23 11:24:30 localhost kernel: Detected 1795.610 MHz processor.
Jul 23 13:40:28 localhost kernel: Detected 1795.607 MHz processor.
Jul 23 13:47:15 localhost kernel: Detected 1795.557 MHz processor.
Jul 23 13:51:40 localhost kernel: Detected 1795.641 MHz processor.
Jul 23 14:20:38 localhost kernel: Detected 1795.646 MHz processor.
Jul 23 14:41:08 localhost kernel: Detected 1795.615 MHz processor.
Jul 23 14:49:27 localhost kernel: Detected 1795.677 MHz processor.
Jul 23 14:56:51 localhost kernel: Detected 1795.596 MHz processor.
Jul 24 07:44:17 localhost kernel: Detected 1795.651 MHz processor.
Jul 24 07:51:07 localhost kernel: Detected 1795.585 MHz processor.
Jul 24 09:05:18 localhost kernel: Detected 1795.660 MHz processor.
Jul 24 10:32:21 localhost kernel: Detected 1795.614 MHz processor.
Jul 24 10:42:39 localhost kernel: Detected 1823.703 MHz processor.
<--------------


2007/7/25, Ingo Molnar <mingo@elte.hu>:
>
> * Henri Hunnekens <henrihunnekens@gmail.com> wrote:
>
> > I've seen that the calbration of the TSC timer was not always done
> > correctly, which resulted in incorrect timers.
> >
> > I found out that local_irq_disable is used before the calibration is
> > started. However with the RT patch applied this does not mean that the
> > interrupts are disabled and therefore the calibration may fails when
> > it's interrupted by an interrupt. Correct me if I'm wrong.
>
> local_irq_disable() still disables interrupts, even in PREEMPT_RT. So
> the problem should be elsewhere. Can you see similar problems on .22-rt
> too? The hrt code saw a number of updates there.
>
>         Ingo
>
