Return-Path: <linux-kernel-owner+w=401wt.eu-S1752667AbYCLFQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbYCLFQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 01:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYCLFQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 01:16:07 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:2399 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYCLFQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 01:16:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=AzlLXmPbsrAD6SOnJKLtDENMreURR/FCXlqDey2jUopjQEg/cYQ3XsCW3c9gukJ0lstUuVT19ukuRSpORmmapqLxrMbaOSo7n0yuTAh8q4v+Fwm5yLojbwfQpZwfsYn5NPlqXoWHkUCxPXSRyjOyoXe04/Wb5dKt9B7msA988Ug=
Message-ID: <47D7670D.1060600@gmail.com>
Date: Wed, 12 Mar 2008 14:15:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] libata: Register for dock events when the drive is	inside
 a dock station
References: <20080221115305.GB5032@homac.suse.de> <47BE26A0.2040708@gmail.com> <20080226101551.GB10721@homac.suse.de> <47C6804A.50705@gmail.com> <20080228110927.GA5745@homac.suse.de> <47C6B1B1.2040602@gmail.com> <20080228155817.GB5593@homac.suse.de> <20080228183243.GA6146@homac.suse.de> <20080228233610.GA3808@homac> <47CCCC46.6070908@gmail.com> <20080311235548.GA4089@homac>
In-Reply-To: <20080311235548.GA4089@homac>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Holger.

Holger Macht wrote:
>> dev_notify is being registered with a pointer to ap.  No wonder it causes
> 
> It seems this change is missing from your patch. I've attached a fixed
> version...

Ah... I must have sent the wrong version of patch.  Thanks for the fix.

>> strange dereferences later on.  Attached is the fixed patch.  Can you
>> please give it a shot?
> 
> ...and now the good news...the new patch works flawlessly with
> 2.6.25-rc5...
> 
> undocking...
> ata5.00: disabled
> ata5.00: detaching (SCSI 4:0:0:0)
> ACPI: \_SB_.GDCK - undocking
> usb 1-6: USB disconnect, address 5
> 
> docking...
> ACPI: \_SB_.GDCK - docking
> ata5: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xa frozen
> ata5: ACPI event
> ata5: soft resetting link
> ata5.00: ATAPI: HL-DT-ST DVDRAM GSA-4083N, 1.08, max UDMA/33
> ata5.00: configured for UDMA/33
> ata5: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x1 t4
> ata5: ACPI event
> ata5: soft resetting link
> ata5.00: configured for UDMA/33
> ata5: EH complete
> scsi 4:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4083N 1.08 PQ: 0 ANSI: 5
> sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
> sr 4:0:0:0: Attached scsi CD-ROM sr0
> sr 4:0:0:0: Attached scsi generic sg1 type 5

Super, I'll forward the patch upstream.

Thanks.

-- 
tejun
