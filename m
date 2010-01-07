Return-Path: <linux-kernel-owner+w=401wt.eu-S932393Ab0AGHeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab0AGHeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322Ab0AGHeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:34:09 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:36358 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265Ab0AGHeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:34:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=AS4n2gQw9aMBMduNaZmUbMBcZ0flmhX/z5EeCxLc6WEDhQqUZTJUEN17ItaF7xdX36
         p0Tmq6XZl69kcqTeFKEXGdOKTpN20d/xa+N808BW2S+H+rqiOf2vXfbh6tu3NN0avOM1
         E/lNK4WXP1O1eHEms7P5Z0XmM/slghhbdX7w0=
MIME-Version: 1.0
In-Reply-To: <20100107065230.GA1303@ucw.cz>
References: <20100106071026.GD1382@ucw.cz> <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com> 
	<20100107065230.GA1303@ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 7 Jan 2010 15:33:46 +0800
Message-ID: <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com>
Subject: Re: sharp c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1
To: Pavel Machek <pavel@ucw.cz>
Cc: dtor@mail.ru, linux-input@vger.kernel.org, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 2:52 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Wed 2010-01-06 15:17:39, Eric Miao wrote:
>> On Wed, Jan 6, 2010 at 3:10 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> >
>> > Sharp-SL code uses strange, complex grouping of gpios for wakeups
>> > toggling. Fortunately, it is unneeded in recent kernels (and actually
>> > provokes WARN_ONs during resume). Remove it.
>> >
>> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>>
>> Pavel,
>>
>> The code to be removed below is used to support pxa27x_keypad
>> to be able to resume from sleep. What's the exact reason to remove
>> this on spitz?
>
> Well, otherwise I get this during resume: (2.6.32 regression)
>
> (and similar for matrix-keypad, but dmitry worked around that
> already).
>
> Problem is that gpio-keys and matrix-keypad want to set_wake for each
> gpio individually, hw can do that, but pxa27x.c breaks it.
>
> I don't get it; what is pxa27x_keypad used on? It looks like
> matrix-keypad subset.
>

pxa27x has its own specific keypad controller. And since we now
use enable_irq_wake, and the keypad controller has only one
such IRQ_KEYPAD, will have to setup the keypad GPIO wakeup
as a whole.
