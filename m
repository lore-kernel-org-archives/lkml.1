Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZCMIh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZCMIh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZCMIhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:37:16 -0400
Received: from xsmtp0.ethz.ch ([82.130.70.14]:23133 "EHLO XSMTP0.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZCMIhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:37:14 -0400
Message-ID: <49BA1B37.9030402@debian.org>
Date: Fri, 13 Mar 2009 09:37:11 +0100
From: "Giacomo A. Catenazzi" <cate@debian.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux* Processor Microcode Data File
References: <2d05c4580903090243k6cf73ee9ubb6c4fccf0f07a2f@mail.gmail.com>	<20090309141655.GA24213@silver.sucs.org>	<20090309081109.376f7a7e@infradead.org>	<20090309153449.GB24213@silver.sucs.org>	<20090309095330.30278385@infradead.org>	<49B8DDDF.8080708@cateee.net> <20090312070759.25d24ab0@infradead.org>
In-Reply-To: <20090312070759.25d24ab0@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Mar 2009 08:37:11.0580 (UTC) FILETIME=[E73ED5C0:01C9A3B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 12 Mar 2009 11:03:11 +0100
> "Giacomo A. Catenazzi" <cate@cateee.net> wrote:
> 
>>> there are various cases where microcode is needed (for example, when
>>> you hotplug a new cpu); request_firmware() is just the right way to
>>> do such things, and an initscript is just the wrong way
>> I don't agree ;-)
>> I agree that request_firmware method is better than init.d scripts,
>> but not that it is the right things. microcodes should be loaded at
>> very beginning of boot process, so by BIOS, by GRUB or on hotpug
>> event by request_firmware.
> 
> ... and how do you do CPU hotplug then ?

and system that doesn't use GRUB vX.Y, and ...

The driver in kernel should remain, for hotplug (CPU not completely
initialized) and for the other cases.

But my argument is that microcode loading in kernel, in "other cases"
is not optimal.
IIRC Intel documentation recommends to update microcodes in BIOS
(before full initialize all registers).

Anyway the "GRUB" proposal will be as an additional way, like BIOS
update: try to load microcode earlier as possible. The worse case
will be done very late, at new package installation time.

But now I've an other doubt:
Users asked me for a script that check and update microcode as
cronjob (I hope nobody will use extreme short "polling" periods to
Intel server.).
Updating microcode at full running time is not supported by
update_firmware method, right?
Is it the correct bahaviour? (according the "load earlier" I think
yes, but maybe I miss something)

>> BTW: why do we have microcode loading modular?
> 
> only the legacy initscript part is modular afaik.

ok

ciao
	cate
