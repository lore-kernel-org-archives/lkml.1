Return-Path: <linux-kernel-owner+w=401wt.eu-S1751311AbXCTQiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbXCTQiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 12:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXCTQiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 12:38:15 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:38028 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbXCTQiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 12:38:14 -0400
Date: Tue, 20 Mar 2007 17:36:18 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Matt Mackall <mpm@selenic.com>
cc: Tasos Parisinos <t.parisinos@sciensis.com>, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel
 version 2.6.20.1)
In-Reply-To: <20070320151530.GD4892@waste.org>
Message-ID: <Pine.LNX.4.61.0703201734300.20032@yvahk01.tjqt.qr>
References: <45FEB8B7.7020200@sciensis.com> <20070319225858.GK10459@waste.org>
 <003501c76afe$3c797a20$0864a8c0@scs1> <20070320151530.GD4892@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 20 2007 10:15, Matt Mackall wrote:
>On Tue, Mar 20, 2007 at 04:44:01PM +0200, Tasos Parisinos wrote:
>> >>+    /* Pre-allocate some auxilliary mpis */
>> >>+    rsa_echo("Preallocating %lu bytes for auxilliary operands\n",
>> >>+         RSA_AUX_SIZE * RSA_AUX_COUNT * sizeof(_u32));
>> >
>> >And printk.
>> 
>> i made such a printk wrapper not to mess with all the printk instances when 
>> i needed to
>> does this hurt, to be left as is?
>
>It's not horrible, but it's not pretty either.

printk(KERN_DEBUG ...) I say.

>> >>+#define RSA_AUX_COUNT         CONFIG_RSA_AUXCOUNT
>> >>+#define RSA_AUX_SIZE         CONFIG_RSA_AUXSIZE
>> >
>> >Just use the config value.
>> >
>> >>+#define RSA_MAX_U32        0xFFFFFFFF
>> >
>> >I'm sure we've got this somewhere.
>> 
>> if you could tell me i will fix it
>
>Hmmm, odd. I can't find one. There are plenty of things that roll
>their own though.

#include <linux/kernel.h>
#define UINT32_T_MAX ((uint32_t)UINT_MAX)

s/RSA_MAX_U32/UINT32_T_MAX/g perhaps?

>And we often skip such prototypes entirely if the .c file can be
>ordered such that no forward declarations are necessary.

Even if <shrug> deallocation functions come before initialisation?


Jan
-- 
