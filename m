Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbXKJTOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbXKJTOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 14:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbXKJTOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 14:14:44 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:4863 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbXKJTOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 14:14:43 -0500
Date: Sat, 10 Nov 2007 13:14:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: x86_64 SATA DVD drive + libata trouble
In-reply-to: <fa.8uxz0HU0qK8mBG2Y3elfa/Plk4k@ifi.uio.no>
To: Bernd Strieder <strieder@informatik.uni-kl.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-id: <47360321.2060803@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.8uxz0HU0qK8mBG2Y3elfa/Plk4k@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Strieder wrote:
> Hello,
> 
> please CC me, I'm not subscribed.
> 
> If any kernel developer is interested in more specific information 
> please mail me, I can build kernels, I can apply patches, though 
> have not done it regularly.
> 
> I'd like to get the DVD drive working somehow. I have googled a lot 
> and did not find any more ideas what to do. Some good keywords to 
> find a solution would suffice at that end.
> 
> Rough problem description:
> 
> I have a Tyan mainboard with NVIDIA chipset CK804. The only 
> SATA/IDE device is a SATA DVD combo, the harddisks are on a RAID 
> controller from 3ware. The harddisks are fine.
> 
> The openSuSE 10.3 boot dvds fail after booting from the BIOS, the 
> installation kernel cannot use the DVD drive. That kernel uses 
> libata and sata_nv pata_amd as drivers. The drive is recognized 
> but it cannot be used. This is the situation probably during 
> install from DVD and now in the running system after a network 
> install it persists.
> 
> Reading from the dvd device /dev/sr0 with dd stops after at most 
> 119kb of rubbish read. Mounting fails with superblock not found.
> When trying to remove the pata_amd module I get an Oops. I tried to 
> remove the modules to have a chance to reload them with other 
> options (atapi_enable), but that did not help, even after 
> rebooting.
> 
> A vanilla 2.6.23.1 kernel behaves even less friendly, the dd 
> on /dev/sr0 causes a hard reset.
> 
> So there are clearly some problems with libata in this system.
> 
> I have failed switching away from libata getting the drive to be 
> recognized at all.

There is a known problem with ATAPI devices on CK804 chipsets which have 
memory above the 4GB mark, being debugged here:

https://bugzilla.redhat.com/show_bug.cgi?id=351451

If you are running into that one you can workaround it for now by 
passing the adma=0 parameter to the sata_nv module (not sure how this 
would be done on Suse's setup) or pass sata_nv.adma=0 on the kernel 
command line if sata_nv is built into the kernel. If that does help, I 
could ask you to test patches :-)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

