Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZHOGAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZHOGAP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 02:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZHOGAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 02:00:14 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:34658 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZHOGAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 02:00:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YNXWMfVJWsUFNo/geRqUg37Q1XNbcTJncZQ+Vi3Vyx2kavkjnMvOBBwT7+koLKiU0+
         wQrokjLQ3VpfVwPHN1ETtSwmdgZrxz6ejpoUd7Dmk6Rh8IAXD4SSRVv/PtqINR211Mte
         zGBRdNgoO0UPnz/ff3gjV+popgrRn/TXHoVpQ=
Message-ID: <4A864EC4.7070907@googlemail.com>
Date: Sat, 15 Aug 2009 07:59:32 +0200
From: Dirk Behme <dirk.behme@googlemail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>,
       Tim Bird <tim.bird@am.sony.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
References: <20090814170228.GM13320@pengutronix.de> <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com> <20090814204305.GA31727@pengutronix.de>
In-Reply-To: <20090814204305.GA31727@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schwebel wrote:
> On Fri, Aug 14, 2009 at 10:04:57PM +0200, Denys Vlasenko wrote:
>>> rsc@thebe:~$ microcom | ptx_ts "U-Boot 2.0.0-rc9"
>>> [  2.395740] <  2.395740>
>>> [  2.395860] <  0.000120>
>>> [  0.000011] <  0.000011> U-Boot 2.0.0-rc9 (Aug  5 2009 - 10:05:58)
>>> [  0.000059] <  0.000048>
>>> [  0.003823] <  0.003764> Board: Phytec phyCORE-i.MX27
>>> [  0.010753] <  0.006930> cfi_probe: cfi_flash base: 0xc0000000 size: 0x02000000
>>> [  0.018711] <  0.007958> NAND device: Manufacturer ID: 0x20, Chip ID: 0x36 (ST Micro NAND 64MiB 1,8V 8-bit)
>>> [  0.026592] <  0.007881> imxfb@imxfb0: i.MX Framebuffer driver
>>> [  0.178655] <  0.152063> dev_protect: currently broken
>>> [  0.178736] <  0.000081> Using environment in NOR Flash
>>> [  0.182577] <  0.003841> initialising PLLs
>>> [  0.367142] <  0.184565> Malloc space: 0xa3f00000 -> 0xa7f00000 (size 64 MB)
>>> [  0.370568] <  0.003426> Stack space : 0xa3ef8000 -> 0xa3f00000 (size 32 kB)
>>> [  0.445993] <  0.075425> running /env/bin/init...
>>> [  0.870592] <  0.424599>
>>> [  0.874559] <  0.003967> Hit any key to stop autoboot:  0
>> boot loader is not fast. considering its simple task, it can be made
>> faster.
> 
> Yup, will check. Almost 1 s seems really long.

Some things to check regarding this and kernel uncompression (copy):

- How often is (compressed/uncompressed) kernel data copied? Once the 
compressed one from storage (NOR/NAND?) to RAM by boot loader? Then by 
kernel's uncompression from RAM to it's final location in RAM?

- For boot loader and uncompression, is D-Cache enabled?

- Is data (image) copy done by optimized functions? Using (a) DMA or 
at least (b) some optimized memcpy using ARM's ldmia/stmia?

Best regards

Dirk
