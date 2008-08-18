Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYHRWOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYHRWOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYHRWO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:14:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39696 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYHRWOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:14:25 -0400
Message-ID: <48A9F407.2080901@zytor.com>
Date: Mon, 18 Aug 2008 15:13:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>	<86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>	<1218898238.3940.6.camel@localhost.localdomain>	<20080816163945.74d487e9@lxorguk.ukuu.org.uk>	<1218903209.3940.14.camel@localhost.localdomain>	<86802c440808161156rf48f23ai9d77ce3cab36f02a@mail.gmail.com>	<1218918341.3940.49.camel@localhost.localdomain>	<86802c440808161334q75a7d019ofade0b6cabf3f74d@mail.gmail.com>	<1218919547.3940.57.camel@localhost.localdomain>	<86802c440808161517y1eaa5a4eo817b8a1bf75945be@mail.gmail.com>	<1218928162.3940.62.camel@localhost.localdomain>	<m14p5i2iwx.fsf@frodo.ebiederm.org>	<1219093158.3261.70.camel@localhost.localdomain>	<m17iaexai3.fsf@frodo.ebiederm.org>	<1219097061.3261.76.camel@localhost.localdomain> <20080818225105.42784da0@lxorguk.ukuu.org.uk>
In-Reply-To: <20080818225105.42784da0@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> I completely agree that irq number 99.9% of the time should be a completely
>>> abstract token.
>> Sure, although one nice reason for doing the abstraction first is that
>> it stops people imposing fragile numbering schemes on irq ...
> 
> On a lot of embedded devices IRQ numbers are not abstract and not
> fragile. I'm all for abstracting out interrupts nicely but it isn't just
> the legacy PC cases to consider - a lot of embedded is at least as
> defined, rigid and meaningfully numbered as ISA.
> 

Note that James said:

> Sure, but you have 16 (or whatever) legacy interrupts.  You still call
> them 1-16 (or ISA-1 through ISA-16).  By the time we reach this stage,
> we're essentially doing string table lookups for the interrupts, so
> there's no need to pre-allocate them (except as a possible arch
> implementation detail).

I think the point is that if we're going to have a meaningful name, it 
should be a string, so we can impose whatever naming scheme makes sense 
for the platform.  Even on embedded platforms it may mean that the flat 
number scheme isn't what makes sense.

	-hpa
