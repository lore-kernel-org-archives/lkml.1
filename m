Return-Path: <linux-kernel-owner+w=401wt.eu-S1750938AbXCECBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938AbXCECBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbXCECAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:00:53 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:7167 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXCECAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hXJGrajK5TY35nc5JzzTfXxulzplGXcAfgKePp8vydgVY7w78XVxW6gQdy+QK8mA/iRzoWZxPBMM93yM9/29NXXTnKWLrXboJUsL7p684OMiO07jpoLSuXGnwj5ZfDvvk6+81wC9FuturSWRnM8M1jRojgDrEzIzy8bvuB3yNpo=
Message-ID: <45EB79C1.3070107@gmail.com>
Date: Mon, 05 Mar 2007 11:00:33 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Mathieu_B=E9rard?= <Mathieu.Berard@crans.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Regression between 2.6.20 and 2.6.21-rc1: NCQ problem with ahci
 and Hitachi drive
References: <45EB6980.90600@crans.org>
In-Reply-To: <45EB6980.90600@crans.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Mathieu.

Mathieu Bérard wrote:
> Hello,
> I have and laptop with an ICH6M SATA Controller and an Hitachi hard drive.
> While it worked well using the ahci module and with NCQ enabled using
> Linux 2.6.20, it does not work anymore (hang at boot) with 2.6.21-rc*
> 
> My drive is among those that were recently blacklisted (see lkml post
> "[PATCH] libata:
> add NCQ blacklist entries from Silicon Image Windowsdriver)
> (Model Number: HTS541010G9SA00 and Firmware Revision: MBZOC60D)
> This blacklisting patch is in -mm now.
> So there is probably a drive related issue here, I'm just wondering why
> it just work
> flawlessly with a 2.6.20...
> 
> Relevant part of kernel log:
> [   16.044663] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [   16.089475] ata1.00: ATA-7: HTS541010G9SA00, MBZOC60D, max UDMA/100
> [   16.089525] ata1.00: 195371568 sectors, multi 0: LBA48 NCQ (depth 31/32)

No, your drive isn't blacklisted yet.  NCQ is still being enabled.

> [   16.091804] ata1.00: configured for UDMA/100
> [   18.151756] SCSI device sda: write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
[--snip--]
> [   18.151856] SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
> [   18.151911] sda: Write Protect is off
> [   18.151977] SCSI device sda: write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [....]
> [   48.143940] ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2
> frozen
> [   48.143999] ata1.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0
> cdb 0x0 data 4096 in
> [   48.144000]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)

It looks like IRQ isn't getting through.  Does giving "acpi=off" kernel
parameter make any difference?

-- 
tejun
