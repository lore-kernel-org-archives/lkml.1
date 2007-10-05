Return-Path: <linux-kernel-owner+w=401wt.eu-S1764099AbXJEUe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764099AbXJEUe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761765AbXJEUes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:34:48 -0400
Received: from spirit.analogic.com ([204.178.40.4]:2382 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760057AbXJEUer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:34:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 05 Oct 2007 20:34:25.0868 (UTC) FILETIME=[1ECF50C0:01C8078F]
Content-class: urn:content-classes:message
Subject: Re: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
Date: Fri, 5 Oct 2007 16:34:25 -0400
Message-ID: <Pine.LNX.4.61.0710051623060.29533@chaos.analogic.com>
In-Reply-To: <47069982.9030009@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: __LITTLE_ENDIAN vs. __LITTLE_ENDIAN_BITFIELD
Thread-Index: AcgHjx7YmuDr6CQHQICZHzoOaEeuFg==
References: <4706822D.4070509@freescale.com> <Pine.LNX.4.64.0710052031310.13406@fbirervta.pbzchgretzou.qr> <470691EB.7020209@freescale.com> <Pine.LNX.4.64.0710052138070.13406@fbirervta.pbzchgretzou.qr> <470694E0.7030408@freescale.com> <jed4vtnxa5.fsf@sykes.suse.de> <47069982.9030009@freescale.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Timur Tabi" <timur@freescale.com>
Cc: "Andreas Schwab" <schwab@suse.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 5 Oct 2007, Timur Tabi wrote:

> Andreas Schwab wrote:
>
>> The bit mapping on your device is strictly internal to the device and
>> has nothing to do with bit order on the C level.
>
> Then I don't understand that point of defining __LITTLE_ENDIAN_BITFIELD.

   What does it mean for a C-level bitfield ordering to be little-endian if the
   processor is BIG_ENDIAN?
>
> -- 
> Timur Tabi
> Linux Kernel Developer @ Freescale
> -

It makes no sense because a bitfield is something having to
do with a 'C' compiler and it must NEVER be used as a template
to address hardware! 'C' gives no guarantee of the ordering
within machine words. The only way you can access them is
using 'C'. They don't have addresses like other objects
(of course they do exist --somewhere). They are put into
"storage units," according to the standard, and these
storage units are otherwise undefined although you can
align them (don't go there).

If you want to call machine-control bits by name, just
define them as hexadecimal numbers (unsigned ints) and,
if your hardware is for both little/big endian, use
a macro that resolves the issue between the number
and the hardware.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
