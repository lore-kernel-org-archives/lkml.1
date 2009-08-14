Return-Path: <linux-kernel-owner+w=401wt.eu-S1754826AbZHNVCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbZHNVCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754722AbZHNVB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:01:59 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:34992 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbZHNVB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kckObkZ6zdkLL/t+RC05jr/XeIIvngK72ZvbWOSJEONtN0/+3p37LgfN99OfqjoIxw
         NVHtFxaYFio9AXMe+qGf2NZDe3mDRcPpklP6xvHPEKwoNutfBrX8kk3rZjeplFJMLQCP
         rvOAUqwhNKyLHDBqXFsTErT81gdh8FISGTTnE=
MIME-Version: 1.0
In-Reply-To: <20090814185731.GN13320@pengutronix.de>
References: <20090814170228.GM13320@pengutronix.de> <4A85AAC4.7050505@acm.org>
	 <20090814185731.GN13320@pengutronix.de>
Date: Fri, 14 Aug 2009 23:01:58 +0200
Message-ID: <63386a3d0908141401t6050f39ey8d85213aeccf748a@mail.gmail.com>
Subject: Re: New fast(?)-boot results on ARM
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Zan Lynx <zlynx@acm.org>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/14 Robert Schwebel <r.schwebel@pengutronix.de>:
> On Fri, Aug 14, 2009 at 12:19:48PM -0600, Zan Lynx wrote:

>> > That's factor 70 away from the 110 ms boot time Tim has talked about
>> > some days ago (and he measured on an ARM cpu which had almost half
>> > the speed of this one), and I'm wondering what we can do to improve
>> > the boot time.
>>
>> 2.4s in uncompression? That seems like an obvious target for
>> improvement.
>
> Indeed, we'll check that.

We got rid of uncompression on a flash-based system vastly improving
boot time. The reason is that compressed kernels are faster only when
the throughput to the persistent storage is lower than the decompression
throughput, and on typical embedded systems with DMA the throughput to
memory outperforms the CPU-based decompression.

Of course it depends on a lot of stuff like performance of flash controller,
kernel storage filesystem performance, DMA controller performance,
cache architecture etc so it's individual per-system.

Linus Walleij
