Return-Path: <linux-kernel-owner+w=401wt.eu-S935448AbXEVTyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935448AbXEVTyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXEVTyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:54:17 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:43674 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758248AbXEVTyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:54:16 -0400
Date: Tue, 22 May 2007 21:53:51 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: John Sigler <linux.kernel@free.fr>
cc: linux-kernel@vger.kernel.org
Subject: Re: Dumping the checksums in a module
In-Reply-To: <4652A635.8070507@free.fr>
Message-ID: <Pine.LNX.4.61.0705222149160.4452@yvahk01.tjqt.qr>
References: <464DC019.6010008@free.fr> <Pine.LNX.4.61.0705182225450.9015@yvahk01.tjqt.qr>
 <4652A635.8070507@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22 2007 10:13, John Sigler wrote:
>> > How do I list the checksums within a module?
>> > Is there a simpler way to list all the checksums?
>> 
>> 22:25 ichi:~ > modinfo aes
>> srcversion:     8CB82B3A254D5A950FD0D14
>> 
>> I think this one checksum is computed out of all functions that
>> the module uses.
>
> You've enabled MODULE_SRCVERSION_ALL which adds a checksum computed from the
> source files used to build a given module. What I want is to list ALL the
> checksums of the symbols included inside a given module.
>
> e.g. for the kernel:

for i in `nm 
/lib/modules/2.6.18.8-ccj45-default/kernel/block/as-iosched.ko |
grep " U " | cut -b 20-`; do
    grep '\b'"$i"'\b' Module.symvers;
done;

(for 32-bit, use `cut -b 12-`)


	Jan
-- 
