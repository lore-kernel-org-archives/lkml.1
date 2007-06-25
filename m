Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbXFYDlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbXFYDlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 23:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936AbXFYDlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 23:41:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:4816 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbXFYDlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 23:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ASwnXHq72AykDLd+VMvMHSCm83ZOnrEP0myQW9d97N1N7BN0zMHGA7yTIMIu/eIFHHf30xUreQ8RqnHv/MG9XCnz5FeNHCaTg7wAxK/mKnd2IoC7BtMD7mkgY7bL6XSP6NSAFSWD21gN/GgxAjwNOW5m6dnJagRwYdaYrVqGeGM=
Message-ID: <8d6898730706242041q61f56b07kf4dc181fdad4e4dc@mail.gmail.com>
Date: Mon, 25 Jun 2007 09:11:09 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: "Carlo Wood" <carlo@alinoe.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "=?ISO-8859-2?Q?Tomasz_K=B3oczko?=" <kloczek@rudy.mif.pg.gda.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <20070624224411.GB21724@alinoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
	 <20070624200837.16e11305@the-village.bc.nu>
	 <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
	 <20070624215724.025a5de5@the-village.bc.nu>
	 <20070624224411.GB21724@alinoe.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I sent a patch to the ALSA developers 4 years ago.
> It was never included in the kernel :/

ALSA maintainers are very open to patches. try sending this again

>
> Here's the comment from a script that I once wrote to
> make some closed-source dinosar code run (speech recognition)
> on modern linux:
>
> # Note that ALSA (Advanced Linux Sound Architecture), the sound drivers that
> # replace the older OSS as of kernel 2.5, also introduce a problem for some
> # soundcards: unlike the OSS drivers, the ALSA drivers limit the recording
> # buffer to the hardware limit of your sound card.  For example, the SB Live!
> # only has two 'period' buffers (called fragments before), and although
> # viavoice requests an 'arbitrary number of periods, size 1024 bytes', it
> # only gets two periods of 1024 bytes: 2048 bytes in total!  The ViaVoice
> # engine however doesn't even process sound until it sees at least 6102 bytes.
> # The 'solution' for this is to increase the buffer size (from 1024 to say
> # 8192), this script also takes care of that.  Unfortunately, also that is
> # possibly not enough: the sound is read from the hardware in chunks of
> # 'period size' and having only two buffers this is often causing an underrun.
> # When ALSA sees an underrun... it stops the sound stream.
>

native ALSA drivers has all these required features.

> My (four year old) patch can be found here:
>
> http://www.xs4all.nl/~carlo17/alsa/index.html
>
> I STILL think that ALSA should restart the stream after an underrun,
> but I am not someone who asks twice :p usually.

If it is native ALSA driver then it will restart after each underrun
and overrun. It is the applications job to do this, alsa-lib provides
all support for this. I have no idea of OSS and OSS emulation in ALSA.

If you have any queries please try sending to alsa-devel.
