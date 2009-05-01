Return-Path: <linux-kernel-owner+w=401wt.eu-S1751282AbZEAEVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282AbZEAEVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 00:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZEAEVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 00:21:35 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:20905 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZEAEVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 00:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iPgSNFtipZL/Th2rFwv6pQOoEIf6yTQ5Z4mBYf7l1OCODH2tHQPsKVCyB+y6C7uvbd
         6VSc6MhJMUEeNDAHw9XmgdLf1MdTeRgMR3g/wAIZ5DMLnfU92bNgXops0mg9sRhikt36
         +aoNBtKJu+p+4s0ZoiU3aOckTIFEKQuuflA1g=
Message-ID: <49FA78B4.2070900@gmail.com>
Date: Thu, 30 Apr 2009 22:21:08 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: Alex Buell <alex.buell@munted.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
 question)
References: <E1LzLgA-0004j6-9W@closure.thunk.org> <49F90CA2.4080602@garzik.org> <20090430083309.437f9248@lithium.local.net> <20090430113445.GA4809@mit.edu> <20090430113814.GB4809@mit.edu> <49FA55A0.8080303@gmail.com> <20090501025132.GA7275@mit.edu>
In-Reply-To: <20090501025132.GA7275@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Thu, Apr 30, 2009 at 07:51:28PM -0600, Robert Hancock wrote:
>>> Thinking about this a bit more, I'll bet the problem is the BIOS
>>> setting is only affecting the primary SATA ports (which are being
>>> grabed by ahci) and not the SATA port in the Ultrabay slot (which is
>>> being picked up by either the ata_piix or piix driver).  Sigh...
>> dmesg and lspci -vv output might be useful..
> 
> Here you go...

I'm suspecting that that Ultrabay slot might be using the PATA ports on 
the chipset, with a PATA-SATA bridge chip or something. I haven't seen 
an Intel chipset with some SATA ports using AHCI and some in PIIX mode 
before, the ones I've seen with both had the PIIX mode driving PATA 
ports. If it is indeed bridged through PATA on that laptop, there's no 
way you're going to get any NCQ support on that slot.

I don't know why Lenovo would do that, as it would kind of cripple SATA 
drives in that slot, but hardware people do some bizarre things sometimes..
