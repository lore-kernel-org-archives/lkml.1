Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbZKRQ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbZKRQ2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbZKRQ2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:28:50 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:43258 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757697AbZKRQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:28:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QkEsIaJIkvR74T8fIdGN4h2OF5IUpBO4WjrzFUwLx4GO/c6MEsGS77zqS3euYR1Cbt
         2erh9NrtTJG3O1KsJ2VVcO0vDsyhL9TGnW1VSHPVzAPKcbzYZFxfZP0mjwPGtJaCt7dc
         SzTuLEBq2+YYev2T/BVQIRJQiL/NOn2+qX/50=
MIME-Version: 1.0
In-Reply-To: <20091118010520.4cd397d4@lxorguk.ukuu.org.uk>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com>
	 <20091107210147.3e754278@hyperion.delvare>
	 <4AF7148C.9090706@thebigcorporation.com>
	 <20091112211255.09cd884a@hyperion.delvare>
	 <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
	 <20091116155606.GC29479@sirena.org.uk>
	 <c384c5ea0911171650t1c441dc4v746d31e4154fcb30@mail.gmail.com>
	 <20091118010520.4cd397d4@lxorguk.ukuu.org.uk>
Date: Wed, 18 Nov 2009 17:28:53 +0100
Message-ID: <c384c5ea0911180828x7c857189w3316c93bb78100ab@mail.gmail.com>
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jean Delvare <khali@linux-fr.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 18, 2009 at 2:05 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> I think the yield()s in the device driver code means "I need a small
>> delay before the hardware is ready" which might translate to some
>> arbitrary "let me msleep()" or "do not select this task in the next
>> scheduler run, EVEN IF this task is highest priority".
>
> Yield() in a driver is almost always a bug.
>

I know and that's exactly why I started this thread (and of course,
because I ran into the bug on my system).


> Our timers are very efficient and some day we will need to make jiffies a
> function and stop the timer ticking for best performance. At that point
> timers are probably the most efficient way to do much of this.
>
The problem with I2C bitbanged is the stringent timing, we need a way
to have fine-grained sleeping
mixed with real-time tasks in order to make this work.

As Thomas already said, the hardware is broken (in the sense that I2C
should really rely on hardware timers, i.e. an I2C host controller).

However, much of the cheaper/older/... embedded hardware is broken.
Given that I2C devices are relatively easy on the timing, we need
the least-dirty way that is not buggy in the kernel.

> Be that as it may, yield() in a driver is almost always the wrong thing
> to do.
>
Yes. What is your idea on removing those without breaking
functionality?  Fine-graining sleep()ing?

Regards,
-- 
Leon
