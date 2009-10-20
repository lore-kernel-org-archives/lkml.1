Return-Path: <linux-kernel-owner+w=401wt.eu-S1752279AbZJTV1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbZJTV1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 17:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZJTV1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 17:27:53 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63764 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZJTV1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 17:27:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DX0PiqghZrxHucjX46fJJ6bGZl26H0pbfSASllJq3plSywOmHs9Blc69PeT63RlmXV
         GrpJJMxw04K1EOagRV1VnC4d/0Mwz7nVXuUsAYDKgEJ4CflJIJFoRy57eFcFXLlSUb7V
         ejEgrxrrnmd971eV7rBissfmd8xLAVJFXHgig=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0910200454300.2863@localhost.localdomain>
References: <1255819715-19763-1-git-send-email-linus.walleij@stericsson.com>
	 <alpine.LFD.2.00.0910200454300.2863@localhost.localdomain>
Date: Tue, 20 Oct 2009 23:27:55 +0200
Message-ID: <63386a3d0910201427i1dd8c789i1c9bceeea250d98c@mail.gmail.com>
Subject: Re: [PATCH] Make MIPS dynamic clocksource/clockevent clock code 
	generic
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
       Mikael Pettersson <mikpe@it.uu.se>, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/20 Thomas Gleixner <tglx@linutronix.de>:

> On Sun, 18 Oct 2009, Linus Walleij wrote:
>> This moves the clocksource_set_clock() and clockevent_set_clock()
>> from the MIPS timer code into clockchips and clocksource where
>> it belongs.
> (...)
> Please do not make that functions inline. They are too large and there
> is no benefit of inlining them.

I think there is, because these functions in MIPS if I'm not misreading it, are
used once each in one and one spot only in the clocksource/clockevent
set-up at boot time for each platform in which they are currently used.

Further these spots tend to be __init or even __cpuinit code segments,
so they will be discarded and if we inline the code it will be discarded
after boot as well.

If you foresee that the code will be used in other ways under other
circumstances, I will make them non-inlined of course, but I have a
hard time seeing that.

OK?

Linus Walleij
