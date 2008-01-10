Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbYAJFp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbYAJFp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 00:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbYAJFpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 00:45:51 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34628 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYAJFpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 00:45:50 -0500
Message-ID: <4785B10C.3040107@garzik.org>
Date: Thu, 10 Jan 2008 00:45:48 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matthew Hall <mhall@mhcomputing.net>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sata_nv does not function in kernel > 2.6.20.21
References: <20080110024733.GC9461@mhcomputing.net> <4785A1CF.7050006@garzik.org> <20080110052520.GA9901@mhcomputing.net>
In-Reply-To: <20080110052520.GA9901@mhcomputing.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Hall wrote:
> On Wed, Jan 09, 2008 at 11:40:47PM -0500, Jeff Garzik wrote:
>> Error -16 is EBUSY, which causes the driver load to fail due to the "Unable 
>> to reserve mem region" message.
>>
>> This means that the sata_nv driver needed to use PCI BAR 6, but was unable 
>> to for some reason.  Given that sata_nv uses devres like other libata 
>> drivers, IMO the likely cause is outside the ATA subsystem (PCI? ACPI?).
> 
> I will follow up on this with the appropriate subsystem lists ASAP. 
> Thanks for getting me redirected appropriately.
> 
>> One workaround to try is setting sata_nv module option 'adma' to zero (0), 
>> in the hopes that it ignores that final region and work anyway.
> 
> I am not quite sure what to do about this part... my boot device for the 
> system is on one of the sata_nv channels which remains functional and 
> does not get disabled by the resource conflict.
> 
> How shall I best attempt the suggested workaround without having to 
> delete the sata_nv driver from the kernel thus rendering the kernel 
> unbootable on this machine? Is there some way to pass the appropriate 
> option at boot instead of at module load time or some file I could 
> modify to enable the specified option in the code?

If you build the driver into the kernel, then pass "sata_nv.adma=0" on 
the kernel command line.

Otherwise, look into how your distro sets module options... probably 
editing /etc/modprobe.conf.  You may need to regenerate critical boot 
files such as initramfs (aka initrd) afterwards, again distro specific 
(try mkinitrd).  Set module option "adma=0" for the sata_nv module.

	Jeff



