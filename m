Return-Path: <linux-kernel-owner+w=401wt.eu-S936967AbXG3Ocd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936967AbXG3Ocd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 10:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbXG3OcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 10:32:23 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:38340 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbXG3OcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 10:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VPvzz+6k2FmFQW3lBnW8kPjCXYKsBjcZRIHY4JZDfjWiu7VQ8aUyvL2U5lsf6tJOaifrRmRnt68f6W4yVkxfiRO5Tsr7I51qif0WkswYxOE4Hw14fU8XgKovLqMyR3IPuKEvMeL7tweqhdfvM7tHczb/Mchj36/HOf62Hd7Utfg=
Message-ID: <6bffcb0e0707300732s6a63e63g4622ebfbbe26e479@mail.gmail.com>
Date: Mon, 30 Jul 2007 16:32:20 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Eric Sesterhenn / Snakebyte" <snakebyte@gmx.de>
Subject: Re: Time Problems with 2.6.23-rc1-gf695baf2
Cc: "Len Brown" <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-acpi@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070725231714.GA24867@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070723221630.GA28951@alice>
	 <6bffcb0e0707241614s7b563b5bu114d2ecb227b1557@mail.gmail.com>
	 <20070725113349.GB5469@alice> <200707251250.22469.lenb@kernel.org>
	 <20070725231714.GA24867@alice>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On 26/07/07, Eric Sesterhenn / Snakebyte <snakebyte@gmx.de> wrote:
> * Len Brown (lenb@kernel.org) wrote:
> > > > > > [   13.506890] ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating _PTC [20070126]
> > > > > > [   13.507101] ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating _TSS [20070126]
> >
> > Note that these are just noise -- new code being verbose when looking for an optional feature.
> >
> > The fact that hitting the power button a bunch of times
> > to make the system move along suggests some sort of missing interrupt problem --
> > most likely the timer itself.
> >
> > [   13.868574] Probing IDE interface ide0...
> > [  387.279576] Clocksource tsc unstable (delta = 370195339890 ns)
> >
> > 5-minutes -- a long probe:-)
> >
> > > CONFIG_NO_HZ=y
> >
> > does CONFIG_NO_HZ=n make a difference?
>
> [   41.007654] EXT3 FS on hda1, internal journal
> [  322.133656] Clocksource tsc unstable (delta = 276476174785 ns)
> Boot went fine but the system got pretty unresponsive later, 2-3 seconds
> delay after keypresses on an idle system and a hang during shutdown which i had to resolve by
> pressing the power button (not to switch it of the hard way, but to keep it rebooting)
>
> > > CONFIG_HIGH_RES_TIMERS=y
> >
> > does CONFIG_HIGH_RES_TIMERS=n make a difference?
>
> doesnt change anything
>
> > does "irqpoll" make any difference?
> > does "notsc" make any difference?
> > does "idle=poll" make any difference?
>
> I tried these with the HIGH_RES_TIMERS=n, irqpoll and notsc dont change
> a thing, idle=poll makes it boot normally

Please use git-bisect

git-bisect start
git-bisect bad
git-bisect good 7dcca30a32aadb0520417521b0c44f42d09fe05c

>
>
> Greetings, Eric
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
