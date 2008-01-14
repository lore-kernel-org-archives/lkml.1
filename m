Return-Path: <linux-kernel-owner+w=401wt.eu-S1751394AbYANMt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbYANMt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 07:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbYANMtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 07:49:20 -0500
Received: from saeurebad.de ([85.214.36.134]:34419 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYANMtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 07:49:19 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Marc Pignat" <marc.pignat@hevs.ch>,
       wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] watchdog on gpio
References: <200801101611.08867.marc.pignat@hevs.ch>
	<8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
	<20080114090329.6efa2921@lxorguk.ukuu.org.uk>
	<8bd0f97a0801140128i2ebf9236uabe0e0b8cf15fbe@mail.gmail.com>
	<20080114092905.227c5a38@lxorguk.ukuu.org.uk>
	<8bd0f97a0801140145s5e13083ej926aa9d5f87e3a99@mail.gmail.com>
Date: Mon, 14 Jan 2008 13:49:51 +0100
In-Reply-To: <8bd0f97a0801140145s5e13083ej926aa9d5f87e3a99@mail.gmail.com>
	(Mike Frysinger's message of "Mon, 14 Jan 2008 04:45:25 -0500")
Message-ID: <87zlv8k1w0.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Mike Frysinger" <vapier.adi@gmail.com> writes:

> wonder if we could design a printk designed for __init functions to
> address this in a clean fashion.
> #define init_printk(fmt, __VA_ARGS__) \
>   do { \
>     static const __init char __fmt[] = fmt; \
>     printk(__fmt , ## __VA_ARGS__); \
>   } while (0)
>
> (yes, i know this isnt perfect as you'd need to pass back the return
> value of printk(), but it's an idea)

How about:

#define init_printk(fmt, args...) ({		\
        static const __init char __fmt[] = fmt;	\
        printk(__fmt, args);			\
})

Now it returns the printk result.

	Hannes
