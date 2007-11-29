Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbXK2QVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbXK2QVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758808AbXK2QUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:20:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:47697 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbXK2QUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:20:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BqIU+0EtOGIbpaH/a7fBxRgS5DQ21g8iJV0w91E6pSrSPX0xf1yYcskHgDq2vTZXf02VOwYwMEE/KLThWkiOyS0nec2gZSSwdpiYRozZxmjUUKaALAJk0EtioUyoiDTMMCsXsGBpvi/dMCMF6WxXIBYghRoeajh1JWUYhDYCl0U=
Message-ID: <3efb10970711290820x5441669fi7f846b0a47004d10@mail.gmail.com>
Date: Thu, 29 Nov 2007 17:20:52 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH PREEMPT_RT]: On AT91 ARM: GPIO Interrupt handling can/will stall forever
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Daniel Walker" <dwalker@mvista.com>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <3efb10970711290733m59e30b5eyf96b914d63a72058@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3efb10970711280638l3f57104y8cf9f2e58235c3@mail.gmail.com>
	 <20071128200550.GA3494@flint.arm.linux.org.uk>
	 <Pine.LNX.4.58.0711281510580.4247@gandalf.stny.rr.com>
	 <3efb10970711290214v37d85a27k9a84876d9099d7c5@mail.gmail.com>
	 <20071129102506.GB22793@flint.arm.linux.org.uk>
	 <3efb10970711290327s3c60da1ey3b6fae738090ca5@mail.gmail.com>
	 <20071129133604.GA23845@flint.arm.linux.org.uk>
	 <3efb10970711290618v2bd93edfrbc53d9df4b73b33b@mail.gmail.com>
	 <20071129142920.GB23845@flint.arm.linux.org.uk>
	 <3efb10970711290733m59e30b5eyf96b914d63a72058@mail.gmail.com>
X-Google-Sender-Auth: b5f3742261ac5d00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I tested some more with the edge_triggered interrupt handler on AT91,
and I had already a long time a problem with the AT91SAM9261-EK kit,
that the DM9000 Ethernet controller did not work _at all_ on RT. I
just tried if the edge triggered interrupt handler works on that board
also. And now that board also works properly on RT. (my first patch
did not solve this problem either, so apparantly that one still misses
interrupts.)

This proves again that the simple_irq usage on AT91 is just crap...

Russell, Thanks again for the latest (and greatest) hint. This saves
me a lot of debug time on that board.

Kind Regards,

Remy

2007/11/29, Remy Bohmer <linux@bohmer.net>:
> Hello Russell,
>
> > While I realise that, I'm telling you that the _problem_ is being
> > caused by the wrong handler being used.
>
> Okay, I believe you... (someone told me once, Russell is right, and if
> you do not believe him, he is still right ;-)
>
> > SA1100 and PXA have exactly the same setup.  They use the correct
> > handler.  Why is AT91 special?
>
> This remark is what convinced me :-))
>
> I changed the interrupt handler from the simple_irq to the edge_irq,
> and it works...!!
> (I added a noop routine for that .ack part, because there is no ack)
>
> I believe I was too focussed on the masking bug in the RT kernel on
> the simple_irq() that I did not see that for the AT91 series the edge
> type interrupt handler also works... (even better...) What I thought
> was 1 single bug in the RT-kernel turned out to be a number of things
> together that aren't correct, even for mainline.
>
> So, to come to a conclusion: The masking bug in RT is still there in
> the simple_irq path, and masking has to be removed from the simple_irq
> code. Also for mainline. AT91 can live without simple_irq.
> I think we are in sync again...
>
> I will post a patch for the AT91 later on, after some more testing.
>
>
> Kind Regards,
>
> Remy
>
