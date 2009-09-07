Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbZIGBdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbZIGBdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 21:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758409AbZIGBdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 21:33:09 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:7768 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758367AbZIGBdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 21:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lozRUoWCmN3gG8xS0ZclLJGZtjwcctqROKAbgz3TSLoi7lheXcHEdLMYXEYP5I9BRc
         YzZ4va8V6eeeGRQL86xSP/B4RCzw6BP9F7a1rDDsWsweMVano1sy510U/Ejm3UflOupE
         I61Qq2hgZrony5f6rGCS3U+LXA4Li61E3Wni8=
MIME-Version: 1.0
In-Reply-To: <1252276145.17852.15.camel@dax.rpnet.com>
References: <20090906052653.GB1324@ucw.cz> <1252276145.17852.15.camel@dax.rpnet.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 7 Sep 2009 09:06:29 +0800
Message-ID: <f17812d70909061806y651c390w1faa5364f0fb6ddc@mail.gmail.com>
Subject: Re: Zaurus suspend saga
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Pavel Machek <pavel@ucw.cz>, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       utx@penguin.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 7, 2009 at 6:29 AM, Richard Purdie<rpurdie@rpsys.net> wrote:
> On Sun, 2009-09-06 at 07:26 +0200, Pavel Machek wrote:
>> fatal reads invalid values -- -108 -- probably because spi is not ready?
>>
>> is spi suspend/resume required? yes.; and yes spi is resumed too late
>>  in the sequence. Or perhaps fatal battery check is way too early.
>>
>> Could someone confirm that simply removing sharpsl_fatal_check() fixes
>> zaurus suspend on 2.6.31?
>
> Sadly lack of time means I've lost track of the Zaurus kernels but this
> sounds like all accesses to the SSP buses now go through the SPI layer
> and when it was converted nobody thought about the impact this would
> have on the Zaurus charger code.
>
> If suspend/resume is broken in this way, it also means the charger code
> is also likely to be totally broken/malfunctioning since it won't be
> able to read from the ADC either.
>
> Either:
>
> a) Someone steps up and finds a way to partially resume the kernel so
> the "offline" charging code can work and access SPI
> b) We find some other way to allow the SPI interface to be accessed by
> the charger code without resuming the whole kernel (the way it used to
> work)
> c) We rip the whole thing out and stop supporting "offline" charging.
>
> I'd hate to see c) happen but I doubt I'm going to find time to rewrite
> that code any time soon and nobody else even seems to have grasped how
> deep this problem really is :(.
>

Yeah, I'd agree that to rebuild the charger code on top of SPI, and possibly
as individual driver in the resume process (so order can be arranged) might
be the final solution, however, that's not an easy job indeed.
