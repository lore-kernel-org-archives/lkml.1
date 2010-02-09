Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab0BIDZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 22:25:56 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:35378 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab0BIDZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 22:25:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VyOabq31qMWK6ivsWR4TlvqTDJ1OCzXuX8Yx40P6QcutPUUAllPLReDy7yKe2ww7Dz
         9OeqjiThQPdaf4pJT78a8mT++HgtCp1sthID7Zdv7bMpg3+HCLbCEHUd5jzAI1weERRd
         UZnOiA/Sd6zetFKfqUtsuli5QzAjfbc169zgw=
Message-ID: <4B70D75A.7010600@gmail.com>
Date: Tue, 09 Feb 2010 12:32:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: davidsen@tmr.com, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-ext4@vger.kernel.org
Subject: Re: 2.6.33-rc6 crashes on resume
References: <4B70982F.8090208@roadwarrior3.tmr.com> <201002090016.18027.rjw@sisk.pl>
In-Reply-To: <201002090016.18027.rjw@sisk.pl>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 08:16 AM, Rafael J. Wysocki wrote:
> On Tuesday 09 February 2010, Bill Davidsen wrote:
>> Pretty simple to reproduce, boot, suspend, press shift
>>
>> Acer Aspire 1681, Celeron, 2.6.33-rc6. Trace and config attached.
> 
> This looks suspicious:
> 
> Feb  8 17:32:47 roadwarrior3 kernel: ata2.00: ACPI cmd 03/42:00:00:00:a0:ef (CFA REQUEST EXTENDED ERROR) rejected by device (Stat=0x51 Err=0x04)
> Feb  8 17:32:47 roadwarrior3 kernel: sd 0:0:0:0: [sda] Starting disk
> Feb  8 17:32:47 roadwarrior3 kernel: ata2.00: ACPI cmd 00/0c:00:00:00:a0:ef (NOP) rejected by device (Stat=0x51 Err=0x04)
> Feb  8 17:32:47 roadwarrior3 kernel: ata2.00: configured for UDMA/33
> Feb  8 17:32:47 roadwarrior3 kernel: firewire_core: rediscovered device fw0
> Feb  8 17:32:47 roadwarrior3 kernel: ata1.00: ACPI cmd 03/45:00:00:00:a0:ef (CFA REQUEST EXTENDED ERROR) rejected by device (Stat=0x51 Err=0x04)
> Feb  8 17:32:47 roadwarrior3 kernel: ata1.00: ACPI cmd 00/0c:00:00:00:a0:ef (NOP) rejected by device (Stat=0x51 Err=0x04)
> Feb  8 17:32:47 roadwarrior3 kernel: ata1.00: configured for UDMA/100

These aren't harmful in themselves.  It just means that the device
failed commands BIOS requested via ACPI.  Just in case, does
"libata.noacpi=1" make any difference to the oops?

Thanks.

-- 
tejun
