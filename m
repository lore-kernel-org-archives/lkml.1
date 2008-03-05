Return-Path: <linux-kernel-owner+w=401wt.eu-S1764524AbYCEWfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764524AbYCEWfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYCEWfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:35:22 -0500
Received: from py-out-1112.google.com ([64.233.166.182]:54852 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbYCEWfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=X0wpSFx1oLvuNpacdww9cOJoOy2y689LGjflrO3j6HEQBYKEBUQygQ3I2eO2WAqOKvMpLkoDdsdc4e6gyZDxERKFvyEixH7613OdQKurL237Z4JSQHZXStqKmdeDIH760gfrH+UwLTmThvfdqWGtI0MsTpX0f5qqvUyasddiUQ0=
Message-ID: <3efb10970803051435y18f82903k729e2b2d1523d15c@mail.gmail.com>
Date: Wed, 5 Mar 2008 23:35:20 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] atmel_tc clocksource/clockevent code
Cc: "David Brownell" <david-b@pacbell.net>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>, akpm@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Nicolas Ferre" <nicolas.ferre@rfo.atmel.com>,
       "Andrew Victor" <linux@maxim.org.za>,
       "john stultz" <johnstul@us.ibm.com>
In-Reply-To: <alpine.LFD.1.00.0803051742190.3099@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204636061-6275-1-git-send-email-hskinnemoen@atmel.com>
	 <1204636061-6275-2-git-send-email-hskinnemoen@atmel.com>
	 <3efb10970803041142l4a03dbb9uf11651d4cc7dde96@mail.gmail.com>
	 <200803041247.50877.david-b@pacbell.net>
	 <3efb10970803050317k68da7154w334561cc5efed637@mail.gmail.com>
	 <alpine.LFD.1.00.0803051742190.3099@apollo.tec.linutronix.de>
X-Google-Sender-Auth: 8d4051d9375295e7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

>  > Attached I have put a screendump of my ETM debugger. It shows a
>  > complete flow of kernel function-calls of what happens on a timer
>  > interrupt. In this example the complete sequence takes about 154 us.
>  > Notice that the ETM is non-intrusive, and that the times are real and
>  > accurate in this trace. (you can even see the effects of CPU-caches,
>  > sometimes the same code just runs faster)
>
> Is there any chance to convert this to a text table? Following that
>  png is pretty hard.

I will see what I can do, but this was the easiest way (it was just a
print-screen;-) )
But, will text-dump make it more clear? It could also contain the time
each assembler instruction will take behind the routines...
But, I will look into that tomorrow. (approx. 12 hours from now)

>  > So, hires timestamps -> really really welcome.
>  > hires timers -> there should be a (configurable) minimal resolution
>  > that fits the hardware to not overload the CPU.
>
> clockevents let you set a minimum delta already. This can be set at
>  runtime before registering the device.

But, I want to expose a bigger risk here.
Apparently it is possible that a non privileged user can overload the
system easily, by starting a high frequency periodic timer. The system
will be that busy handling that timer that the system stops
responding, thus it will result in some kind of Denial-of-Service
situation, even on X86.

I think that there should be a hard limit to prevent starting timers
at higher frequencies than they can be handled by the platform,
included the scheduler overhead.

David has proposed a solution via the kernel-commandline, but I think
it should be a hard coded limit, to prevent that it is forgotten by
the end-user to put it on the kernel-cmd-line. Maybe a sub-option that
gets visible when HRT is enabled in menuconfig, this option should be
default very conservative, and the user should think about the lower
bound he really needs before he really gets HRT enabled.

What do you think of this? (I can propose a patch for this tomorrow)


Kind Regards,

Remy
