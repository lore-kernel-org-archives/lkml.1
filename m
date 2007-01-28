Return-Path: <linux-kernel-owner+w=401wt.eu-S1752442AbXA1PlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbXA1PlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 10:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443AbXA1PlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 10:41:23 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:22567 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbXA1PlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 10:41:22 -0500
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jan 2007 10:41:22 EST
Date: Sun, 28 Jan 2007 16:35:06 +0100 (MET)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Bugfixes: PCI devices get assigned redundant IRQs
From: "Andreas Block" <job@andreasblock.de>
Cc: "Xavier Bestel" <xavier.bestel@free.fr>, linux-kernel@vger.kernel.org,
       "Andreas Block" <andreas.block@esd-electronics.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <op.tmrce0km8n9ctc@pc-block.esd>
 <1169809255.10952.178.camel@frg-rhel40-em64t-03>
 <op.tmrh5hxp8n9ctc@pc-block.esd> <45BC5919.8030004@zytor.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tmvewmxdb742fu@pc-andreas>
In-Reply-To: <45BC5919.8030004@zytor.com>
User-Agent: Opera Mail/9.10 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sun, 28 Jan 2007 09:04:41 +0100 schrieb H. Peter Anvin <hpa@zytor.com>:

> I think you're confusing the Interrupt Line register and the Interrupt  
> Pin register.  The Interrupt Line register is platform-dependent, but on  
> x86 platforms it generally contains the IRQ number (and IRQ 0 is valid,  
> although in practice it is never used since IRQ 0 is the system timer  
> and is never connected to the PCI bus), or 255 meaning "none" -- see the  
> footnote on page 223 of the PCI 3.0 spec.

No, I don't think so. I meant the PCI Interrupt Pin register and not the  
Interrupt line register. I do know, that the latter contains a platform  
dependent interrupt assignment. In the former a device states which  
interrupt "trace" the device is connected to (Int A-D).
Perhaps you take at look at the code, I think, it's dealing with the  
register I described (Interrupt pin).

Linus stated his opinion about the patch and thinks, it should be well  
tested in -mm kernel, because it might break devices, which do not comply  
to the PCI spec.
I second that. If there're indeed devices out there, which violate the  
spec in this point, the patch would hurt more, than it's doing any good.
As I wrote in my first message, the consequences of this rather small bug  
(if it is one and not a workaround for bad devices) are harmless.

Regards,
Andreas
