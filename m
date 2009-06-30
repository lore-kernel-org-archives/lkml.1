Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbZF3AhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbZF3AhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZF3AhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:37:12 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:51698 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZF3AhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:37:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=E1G4c5JSIhKRKOXMfjZ65aVAn5YsFc3KhE3v7K+3DAiAf3sSn1UfXXs2DDu/ofpc3V
         N3NqqGTtQM10a8Y7Maj4q4KqykgtXPYie+ZBw1vgan1W4uZISIMLHRq1IsgYWwHFsLuo
         CAqHzys+qQbhOu9himJah3t0jv08UYSZ1xQTA=
Message-ID: <4A495E72.8020800@gmail.com>
Date: Mon, 29 Jun 2009 18:38:10 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Marcin Niskiewicz <mniskiewicz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: hdd errors with libata drivers
References: <b6373cd60906290545w2f9a660ci7c7c51794ecf5f56@mail.gmail.com>
In-Reply-To: <b6373cd60906290545w2f9a660ci7c7c51794ecf5f56@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2009 06:45 AM, Marcin Niskiewicz wrote:
> Hello!
> I have 2 identical machines - both with 3 disks (WDC WD3000HLFS) -
> root filesystem is under raid1, data partitions are in raid5 (using
> mdadm)
> gentoo, kernel version - 2.6.25-hardened-r8, ahci driver for disks...
> reiserfs as filesystem...
> 00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH)
> 6 port SATA AHCI Controller (rev 02)
> Intel(R) Xeon(R) CPU X3360
>
> About 4 months ago both machines died in the same way - due to problem
> with disks - both raid5-s were down, data filesystem was
> unreachable... (the root filesystem survived)
>
> I thought that it was sth linked with power supply or sth similar - so
> I made some changes to avoid the problem ...
>
> But few days ago it happened again - at the SAME time - BOTH machines
> had problems with disks! (again root filesystem survived, data
> partition was corrupted and raid5 was unreachable)
>
> In dmesg I noticed something like this:
>
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata1.00: irq_stat 0x40000001
> ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>           res 51/04:00:34:cf:f3/00:00:00:f3:40/a3 Emask 0x1 (device error)

Here the drive is returning command aborted to a cache flush request, 
suggesting it's having problems writing to the media.

> ata1.00: exception Emask 0x0 SAct 0x7 SErr 0x0 action 0x0
> ata1.00: irq_stat 0x40000008
> ata1.00: cmd 60/08:08:f7:23:8a/00:00:0b:00:00/40 tag 1 ncq 4096 in
>           res 41/40:00:f7:23:8a/21:00:0b:00:00/4b Emask 0x409 (media error)<F>
> ata1.00: status: { DRDY ERR }
> ata1.00: error: { UNC }
> ata1.00: configured for UDMA/133
> ata1: EH complete

And here it's returning an uncorrectable media error to an NCQ read.

>
> On both machines dmesg errors were about ata1.00 ...
>
> Due to http://ata.wiki.kernel.org/index.php/Libata_error_messages it
> looks like hardware problem - but 6 disks in two machines - at the
> same time again?
> I checked all of disks with WD tools before going to production and
> everything was OK... It's really strange ....
>
> I found opinions that it could be kernel bug on ata acpi - and that I
> should add noacpi or noapic option - is it true? wouldn't it have any
> affects (performance etc.) to Intel CPU?

It seems highly unlikely that this is a kernel bug. My guess would be 
something common to both machines, maybe a power problem, etc.

>
> I'm thinking about changing kernel version - maybe not hardened ...
>
> Any ideas?
>
> Thanks for any help!
>
> regards
> nichu

