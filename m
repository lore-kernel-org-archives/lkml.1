Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbXIOIry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbXIOIry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXIOIrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:47:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47479 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752890AbXIOIro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:47:44 -0400
Date: Sat, 15 Sep 2007 10:47:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Rene Herman <rene.herman@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Kai Germaschewski <kai@germaschewski.name>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: Per option CFLAGS?
Message-ID: <20070915084754.GO3563@stusta.de>
References: <46EB141A.7090200@gmail.com> <46EB1599.4020806@zytor.com> <46EB198D.2040208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46EB198D.2040208@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 01:30:21AM +0200, Rene Herman wrote:
> On 09/15/2007 01:13 AM, H. Peter Anvin wrote:
>
>> Rene Herman wrote:
>
>>> I have a single file foo.c that I want to generate two (ALSA) modules
>>> from, snd-foo2000.ko and snd-foo2001.ko, by compiling with either
>>> FOO2000 or FOO2001 defined.
>>>
>>> I can do this, and ALSA does this a few times, by providing dummy
>>> foo2000.c and foo2001.c files, like:
>>>
>>> === foo2000.c
>>> #define FOO2000
>>> #include "foo.c"
>>> ===
>>>
>>> and a regular Makefile
>>>
>>> ===
>>> foo2000-objs := foo2000.o
>>> foo2001-objs := foo2001.o
>>>
>>> obj-$(CONFIG_SND_FOO2000) += snd-foo2000.o
>>> obj-$(CONFIG_SND_F002001) += snd-foo2001.o
>>> ===
>>>
>>> That #include is a little lame though. Is there a nicer way? I noticed
>>> the per-file CFLAGS, but given that it's one source file for both, that
>>> doesn't fit.
>>>
>> The stub source file is usually considered a good way to do this.
>
> Mmm. If I'll have to live with it, I can, but thought I'd ask if there was 
> some nice build trickery available instead.

The usual trick is to create _three_ modules:

Two with the foo2000 and foo2001 specific parts, and a third one with 
all code used by both.

Or if foo2000 and foo2001 differ only in small details, create one 
snd-foo200x module supporting both at the same time.

> Rene.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

