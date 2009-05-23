Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZEWJhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZEWJhR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 05:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZEWJhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 05:37:04 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:63985 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZEWJhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 05:37:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=DuJBo5TDNH6dudnQ9yneskFi/155u0Za9JSxt0IsS9Bc3holnsMb1K1Nc39Wvyi6BY
         t6QWX3c5LMiSG/Q9IzYkDLbnL4qvm8IUH8H09xuFPILNyjS0h/DN51VY1a2oQpCh+7Nr
         3KPIUEFu2B7qP3yLebTGZU6ZAjvOYv78DVNTA=
Message-ID: <4A17C39E.2030302@gmail.com>
Date: Sat, 23 May 2009 11:36:30 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1pre) Gecko/20090521 Shredder/3.0b3pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it> <clqON-2Xv-9@gated-at.bofh.it> <clqON-2Xv-11@gated-at.bofh.it> <clqON-2Xv-13@gated-at.bofh.it> <clqON-2Xv-15@gated-at.bofh.it> <clqON-2Xv-17@gated-at.bofh.it> <clqON-2Xv-19@gated-at.bofh.it> <clqON-2Xv-5@gated-at.bofh.it> <cmknZ-8lW-9@gated-at.bofh.it> <cmoBl-6Ok-21@gated-at.bofh.it> <cmp4n-7rb-15@gated-at.bofh.it> <cmsYg-5BR-27@gated-at.bofh.it> <cmvW7-1Yj-23@gated-at.bofh.it> <cnheh-3vO-7@gated-at.bofh.it> <cnPg1-7Q4-19@gated-at.bofh.it> <cnTWo-7bV-25@gated-at.bofh.it> <co1Kd-350-5@gated-at.bofh.it> <co2Qf-4QQ-27@gated-at.bofh.it> <co4yj-7Mc-5@gated-at.bofh.it> <cp71c-4py-29@gated-at.bofh.it> <cEVyE-re-1@gated-at.bofh.it>
In-Reply-To: <cEVyE-re-1@gated-at.bofh.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2009 11:20 AM, Niel Lambrechts wrote:
> On 04/09/2009 08:18 PM, Tejun Heo wrote:
>> Hmm... none of the debugging messages got triggered, so there should
>> be no noticeable timing change. It seems like you're being lucky for
>> the time being. Can you please keep testing and report back?
>
> Hi Tejun,
>
> Just to keep you up informed - this issue is still happening, I've been
> testing the latest 2.6.30-git kernels the last couple of weeks and just
> checked my logs after having an unexpected fsck upon system boot - the
> freeze seems to trigger very infrequently though, since I use s2disk at
> least twice a day and the error only seems to have happened twice since
> May 2.

I notice that if I hibernate with a CD in the drive and then remove it as soon 
as I boot, I get a hard reset on the ata1 bus.

I'm not sure if this maybe plays a role in triggering the problem at times, 
perhaps it is entirely expected - but vim highlights it in red and to a "normal" 
user that is bad. :)

Maybe after applying your patch I should play around with this?


/var/log/warn:
May 23 11:28:44 linux-7vph kernel: sd 0:0:0:0: [sda] Starting disk
May 23 11:28:44 linux-7vph kernel: ata2: SATA link up 1.5 Gbps (SStatus 113 
SControl 300)
May 23 11:28:44 linux-7vph kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 
SControl 300)
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 
filtered out
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 
filtered out
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 
filtered out
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 
filtered out
May 23 11:28:44 linux-7vph kernel: ata1.00: configured for UDMA/133
May 23 11:28:44 linux-7vph kernel: ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 
action 0x9 t4
May 23 11:28:44 linux-7vph kernel: ata1: irq_stat 0x00400040, connection status 
changed
May 23 11:28:44 linux-7vph kernel: ata1.00: configured for UDMA/133
May 23 11:28:44 linux-7vph kernel: ata1: EH complete
May 23 11:28:44 linux-7vph kernel: ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata2.00: ACPI cmd e3/00:1f:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata2.00: ACPI cmd e3/00:02:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata2.00: configured for UDMA/133
May 23 11:28:44 linux-7vph kernel: pci 0000:00:02.0: restoring config space at 
offset 0x1 (was 0x900407, writing 0x900403)
May 23 11:28:44 linux-7vph kernel: pci 0000:00:02.0: setting latency timer to 64
May 23 11:28:44 linux-7vph kernel: Restarting tasks ... done.
May 23 11:28:44 linux-7vph kernel: ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 
action 0x9 t4
May 23 11:28:44 linux-7vph kernel: ata2: irq_stat 0x40000001
May 23 11:28:44 linux-7vph kernel: ata2.00: configured for UDMA/133
May 23 11:28:44 linux-7vph kernel: ata2: EH complete
May 23 11:28:44 linux-7vph kernel: ata1.00: exception Emask 0x10 SAct 0x1 SErr 
0x10000 action 0xe frozen
May 23 11:28:44 linux-7vph kernel: ata1.00: irq_stat 0x00400008, PHY RDY changed
May 23 11:28:44 linux-7vph kernel: ata1: SError: { PHYRdyChg }
May 23 11:28:44 linux-7vph kernel: ata1.00: cmd 
61/08:00:37:5a:f4/00:00:09:00:00/40 tag 0 ncq 4096 out
May 23 11:28:44 linux-7vph kernel:          res 
50/00:08:37:5a:f4/00:00:09:00:00/40 Emask 0x10 (ATA bus error)
May 23 11:28:44 linux-7vph kernel: ata1.00: status: { DRDY }
May 23 11:28:44 linux-7vph kernel: ata1: hard resetting link
May 23 11:28:44 linux-7vph kernel: ata1: SATA link up 1.5 Gbps (SStatus 113 
SControl 300)
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 
filtered out
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 
filtered out
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 
filtered out
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
May 23 11:28:44 linux-7vph kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 
filtered out
May 23 11:28:44 linux-7vph kernel: ata1.00: configured for UDMA/133
May 23 11:28:44 linux-7vph kernel: ata1.00: configured for UDMA/133
May 23 11:28:44 linux-7vph kernel: ata1: EH complete

Regards,
Niel
