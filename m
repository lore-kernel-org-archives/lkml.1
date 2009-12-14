Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZLNSMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZLNSMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 13:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758038AbZLNSMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 13:12:33 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:54360 "EHLO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbZLNSMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 13:12:33 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: GPIO support for HTC Dream
Date: Mon, 14 Dec 2009 13:12:30 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200E9C6@mi8nycmail19.Mi8.com>
In-Reply-To: <1260813293.13078.15.camel@c-dwalke-linux.qualcomm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: GPIO support for HTC Dream
Thread-Index: Acp85t/t4MmQ1hq7TgGjmv1TFVlsUwAADjTg
References: <20091208102842.GH12264@elf.ucw.cz> <4B1EB57D.6070408@bluewatersys.com> <20091208214658.GC4164@elf.ucw.cz> <4B1ECEEE.3000209@bluewatersys.com> <4B203575.6050407@bluewatersys.com> <20091210172458.GJ19454@elf.ucw.cz> <4B2150B7.3040207@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE190901FB0F92@mi8nycmail19.Mi8.com> <20091211221015.GB24456@elf.ucw.cz> <BD79186B4FD85F4B8E60E381CAEE190901FB10EA@mi8nycmail19.Mi8.com> <20091214064545.GK5114@elf.ucw.cz> <1260813293.13078.15.camel@c-dwalke-linux.qualcomm.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Daniel Walker" <dwalker@codeaurora.org>, "Pavel Machek" <pavel@ucw.cz>
Cc: "Ryan Mallon" <ryan@bluewatersys.com>,
       "Iliyan Malchev" <malchev@google.com>,
       "Brian Swetland" <swetland@google.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Arve Hj?nnev?g" <arve@android.com>,
       "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 18:12:31.0463 (UTC) FILETIME=[00B5F770:01CA7CE9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nBEIDE16004516

On Monday, December 14, 2009 10:55 AM, Daniel Walker wrote:
> On Mon, 2009-12-14 at 07:45 +0100, Pavel Machek wrote:
>> Hi!
>> 
>>> This looks MUCH better!
>> 
>> Thanks :-).
>> 
>>>> arch/arm/Kconfig                     |    1
>>>> arch/arm/mach-msm/board-dream-gpio.c |  327 +++++++++--------------------------
>> ...
>>> Please update (or remove) this diffstat.  It no longer matches the patch.
>> 
>> I was just showing differences to _previous_ version, not what I was sending.
>> 
>>> Ok.  The hardware still seems a bit strange. Is there any datasheet
>>> available?
>> 
>> I don't think there is one. Daniel, can you help here?
>
> I don't know if there is one or not (I'd guess not).. I can't release
> documents, but I could try to address specific questions or find people
> to answer specific questions.

Hello Daniel,

My specific question was about the gpio hardware registers.

>From Pavel's implementation it appears that the gpio's are organized as a
number of 8-bit ports.  Each of these ports only have one 8-bit register.
Writing a '1' to a bit in the register makes the associated pin a high-level
output.  Writing a '0' makes the pin a low-level output or an input pin.
Reading the port at this point will return the actual 'input' level of the pin.

The hardware seems a bit strange and I just wanted to verify that this is
correct.  If it is, this would explain the need to keep the 'shadow' contents
of the port in order to set the 'direction' of a pin.

I was also wondering if the initial 'shadow' value needs to be written to the
port at init in order to correctly establish the output value for specific
pins.

One other thing.  Are the gpio's handled by Pavel's driver actually from the
MSM chip or from an external CPLD?  The registers are all defined as:

+		.reg = reg_num + DREAM_CPLD_BASE,

If they are external from the MSM chip this driver should probably be renamed
to something more appropriate since it is probably dream specific and not
generic to the msm architecture.

Thanks for the help,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
