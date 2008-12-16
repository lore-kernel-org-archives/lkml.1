Return-Path: <linux-kernel-owner+w=401wt.eu-S1758718AbYLPQDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718AbYLPQDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbYLPQCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:02:53 -0500
Received: from main.gmane.org ([80.91.229.2]:56484 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039AbYLPQCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:02:52 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Brian J. Murrell" <brian@interlinx.bc.ca>
Subject: Re: suspend/resume fails on second attempt in LNXVIDEO:00
Date: Tue, 16 Dec 2008 16:02:42 +0000 (UTC)
Message-ID: <gi8jf1$m5f$5@ger.gmane.org>
References: <gi247o$iog$1@ger.gmane.org> <200812160002.43427.rjw@sisk.pl>
	<gi7433$m5f$1@ger.gmane.org> <200812161625.37318.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: d193-213-184.home3.cgocable.net
User-Agent: Pan/0.132 (Waxed in Black)
Cc: linux-acpi@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 16:25:37 +0100, Rafael J. Wysocki wrote:

> Because the hal-driven whitelist allows us to match systems in a more
> detailed way.  If your system is in the s2ram whitelist already and
> works with it, there shouldn't be any difference.

Unfortunately, Ubuntu in their "wisdom" removed s2ram and claim "s2both" 
supersedes it in that it does both suspend to disk and suspend to ram and 
then suspends, but if your battery dies while suspended you can still 
resume from the suspend to disk.
 
> Still, I was only considering that as a debugging aid in your case,
> because s2ram works in the minimal configuration, while hald doesn't.

Right.  I will give s2both a try and see what happens... no joy.  It 
fails to even run without the swap device mounted, and my swap device is 
not big enough to hibernate to anyway.  Damn you Ubuntu.

> That's a bit of new information.
> 
> What's the list of modules loaded in the minimal configuration?

Module                  Size  Used by
ext3                  130568  1 
jbd                    53908  1 ext3
mbcache                16004  1 ext3
loop                   22540  2 
usb_storage            78656  0 
libusual               30356  1 usb_storage
sd_mod                 41240  2 
crc_t10dif             10112  1 sd_mod
sr_mod                 21956  0 
cdrom                  42272  1 sr_mod
sg                     36148  0 
ahci                   37260  1 
ata_piix               29700  0 
pata_acpi              12288  0 
ata_generic            13060  0 
libata                176160  4 ahci,ata_piix,pata_acpi,ata_generic
scsi_mod              156948  5 usb_storage,sd_mod,sr_mod,sg,libata
8139too                31744  0 
8139cp                 27776  0 
mii                    13440  2 8139too,8139cp
ehci_hcd               41996  0 
uhci_hcd               30352  0 
usbcore               149392  5 usb_storage,libusual,ehci_hcd,uhci_hcd
thermal                23708  0 
processor              49708  3 thermal
fan                    12676  0 
fuse                   58780  3 

Cheers,
b.


