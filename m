Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbZD3Hqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbZD3Hqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 03:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZD3Hqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 03:46:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:49259 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZD3Hqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 03:46:37 -0400
Message-ID: <49F95719.10701@kernel.org>
Date: Thu, 30 Apr 2009 16:45:29 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alex Buell <alex.buell@munted.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
 question)
References: <E1LzLgA-0004j6-9W@closure.thunk.org>	<49F90CA2.4080602@garzik.org> <20090430083309.437f9248@lithium.local.net>
In-Reply-To: <20090430083309.437f9248@lithium.local.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 07:45:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Buell wrote:
> On Wed, 29 Apr 2009 22:27:46 -0400, I waved a wand and this message
> magically appears in front of Jeff Garzik:
> 
>> As Tejun noted, try switching to AHCI mode in BIOS.
> 
> But is there a way to switch modes without needing to go through the
> BIOS? Some laptops won't let you do that through BIOS. 

There is and it isn't too difficult either in itself but the problem
is that for ahci mode to work the ABAR (PCI BAR 5) needs to be
allocated and enabled.  On x86, the kernel takes the PCI resources
allocated by BIOS.  Doing it directly isn't necessarily difficult but
is too dangerous as there can be areas which aren't described anywhere
but still are used by something.

Because ICHs don't enable ABAR in piix mode unless SCRAE is set and
most BIOSen don't set SCRAE, ABAR don't get allocated nor its space
get reserved in most cases if the controller is in piix mode.

So, at the point of driver load, there just isn't much we can do about
the missing ABAR.  It's sad.  Dunno why some laptop manufacturers
still program the thing into piix mode.  :-(

Thanks.

-- 
tejun
