Return-Path: <linux-kernel-owner+w=401wt.eu-S1755059AbYANN4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059AbYANN4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYANN4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:56:23 -0500
Received: from saeurebad.de ([85.214.36.134]:36002 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbYANN4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:56:21 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Marc Pignat" <marc.pignat@hevs.ch>,
       wim@iguana.be, linux-kernel@vger.kernel.org
Subject: printk-wrapper with sectionized string constants [was: Re: [RFC, PATCH] watchdog on gpio]
References: <200801101611.08867.marc.pignat@hevs.ch>
	<8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
	<20080114090329.6efa2921@lxorguk.ukuu.org.uk>
	<8bd0f97a0801140128i2ebf9236uabe0e0b8cf15fbe@mail.gmail.com>
	<20080114092905.227c5a38@lxorguk.ukuu.org.uk>
	<8bd0f97a0801140145s5e13083ej926aa9d5f87e3a99@mail.gmail.com>
	<87zlv8k1w0.fsf@saeurebad.de>
	<8bd0f97a0801140503t484ab61clcf41f4e4ea913fe4@mail.gmail.com>
Date: Mon, 14 Jan 2008 14:56:52 +0100
In-Reply-To: <8bd0f97a0801140503t484ab61clcf41f4e4ea913fe4@mail.gmail.com>
	(Mike Frysinger's message of "Mon, 14 Jan 2008 08:03:29 -0500")
Message-ID: <87prw4jysb.fsf_-_@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Mike Frysinger" <vapier.adi@gmail.com> writes:
>> How about:
>>
>> #define init_printk(fmt, args...) ({            \
>>         static const __init char __fmt[] = fmt; \
>>         printk(__fmt, args);                    \
>> })
>>
>> Now it returns the printk result.
>
> i wasnt really worried about that ... i was worried about other random
> things i may have missed

Ok.

> your dropping of ## wont work as you need gcc to expand args and take
> away the , in the simple 1 arg case:
> init_printk("MOO");

Whoops, totally oversaw this one.  Of course, this must be in.

Perhaps an even more generic solution would be good, like this:

#define section_printk(sect, fmt, args...) ({		\
	static const sect char __fmt[] = fmt;		\
        printk(__fmt, ## args);				\
})

And then just have convenience wrappers like {,dev}init_printk, ... etc.

Can someone please shout at us if there is a fundamental problem with
this approach?

	Hannes
