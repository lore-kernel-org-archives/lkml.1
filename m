Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbYG3FvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbYG3FvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 01:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756021AbYG3FvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 01:51:09 -0400
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:58399 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754828AbYG3FvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 01:51:06 -0400
Message-ID: <48900147.7030106@vlnb.net>
Date: Wed, 30 Jul 2008 09:51:03 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Matthew Wilcox <matthew@wil.cx>, Ric Wheeler <rwheeler@redhat.com>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       Jim Meyering <jim@meyering.net>, linux-kernel@vger.kernel.org,
       Martin Petersen <mkp@mkp.net>, Jeff Garzik <jeff@garzik.org>,
       Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: tools support for non-512 byte sector sizes
References: <488F524F.6020905@redhat.com>	 <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain>
In-Reply-To: <1217356645.6103.48.camel@localhost.localdomain>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Tue, 2008-07-29 at 12:26 -0600, Matthew Wilcox wrote:
>> On Tue, Jul 29, 2008 at 01:24:31PM -0400, Ric Wheeler wrote:
>>> Jim pinged me about the use case for having our tool chain (parted 
>>> specifically) support devices with non-512 bytes sectors.
>> Matt Domsch spoke with me about this at OLS.  I took that opportunity,
>> and I'll take this one, to pimp my ata-ram driver which allows you to
>> alter the sector sizse to whatever you want:
>>
>> http://git.kernel.org/?p=linux/kernel/git/willy/misc.git;a=shortlog;h=ata-ram
>>
>> I'll admit to having not tested it with anything other than 512, but it
>> ought to support 4096 byte sectors just fine.  I haven't looked at what
>> would be required to support 520-byte sectors.
> 
> scsi_debug does exactly the same thing, so it reports anything you tell
> it (Martin Petersen actually added this so he could test with 4k
> sectors).
> 
> The problem, which ata_ram also suffers, is that the tools we most need
> to test are the ones for manipulating non volatile characteristics (like
> partition tables).  We'd really like the disk contents to survive reboot
> for this ...

SCST (http://scst.sf.net) fully supports non-512 bytes sectors up to 
4096. Available target drivers for transports: software iSCSI, FC, 
InfiniBand SRP, parallel SCSI, SAS (not much tested, because of lack of 
hardware). With VDISK dev handler you can use files as a backstorage.

I personally for a long time have been working with 4K sectors, because 
it's better for performance, but so far found the only tool, which 
doesn't support them: disktest.

> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
