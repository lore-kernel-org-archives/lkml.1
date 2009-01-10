Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbZAJQX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbZAJQX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 11:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbZAJQXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 11:23:21 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:50292 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbZAJQXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 11:23:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jHxEFcs/LhMNFYUY06fG1sElslxn3b5ghvE9nlWI0Y77KsPTa7KdTW7Nv8Npsd73Dd
         AR1eCOfzHmkjLD82xY5X7mnUlKP8XxOuXQUad+rjkmxwkTTCychN67zUP2DVs5rKJ5Jh
         OgamFI/3qeWcFOhA1uwQdyntkEOJY24hhXuhI=
Message-ID: <4968CB72.6080100@gmail.com>
Date: Sat, 10 Jan 2009 08:23:14 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN
 (4)
References: <49683957.9070700@gmail.com> <49685B70.8080908@shaw.ca>
In-Reply-To: <49685B70.8080908@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Justin P. Mattock wrote:
>> I am seeing this in dmesg:
>> FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
>> not sure what this is.
>> (the only changes to .config was add kexec,
>> coredump, and relocatable kernel options.)
>>
>> I take it that I'm unable to try this relocatable
>> kernel stuff out.(x86_32)?
>>
>> regards;
>>
>> Justin P. Mattock
>
> I believe that indicates your BIOS's FADT table contains inconsistent 
> data. You're sure that only happens with those options set?
>
Well, the positive side is kexec
does work on  macbook pro
(doesn't play so well with the xserver,
garbled screen.).

As for the FADT table, I reverted to an old
.config that has no new options in it, and sure enough
that message appeared. Looking back in my logs,
the last kernel commit I have is:
 2.6.28-07485-g9e42d0c
that doesn't show such messages.

When examining this message
(not too familiar with FADT)
I see PM leading me to believe this maybe has to
do with the PM stuff.
(making me wonder, if this is the reason
suspend isn't working.just a black screen
upon wakeup); but like I said I'm not
familiar with that area.
heres what I see:

[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 3FEFD1C0, 0074 (r1 APPLE   Apple00       
A5       1000013)
[    0.000000] ACPI: FACP 3FEFB000, 00F4 (r3 APPLE   Apple00       A5 
Loki       5F)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match 
PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 3FEF0000, 48D1 (r1 APPLE  MacBookP    20002 
INTL 20050309)
[    0.000000] ACPI: FACS 3FEC0000, 0040
[    0.000000] ACPI: HPET 3FEFA000, 0038 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: APIC 3FEF9000, 0068 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: MCFG 3FEF8000, 003C (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: ASF! 3FEF7000, 00A0 (r32 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: SBST 3FEF6000, 0030 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: ECDT 3FEF5000, 0053 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: SSDT 3FEEF000, 04DC (r1 APPLE     CpuPm     3000 
INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBD000, 064F (r1 SataRe  SataPri     1000 
INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBC000, 069C (r1 SataRe  SataSec     1000 
INTL 20050309)
[    0.000000] ACPI: Local APIC address 0xfee00000

and looking at
 2.6.28-07485-g9e42d0c

[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 3FEFD1C0, 0074 (r1 APPLE   Apple00       
A5       1000013)
[    0.000000] ACPI: FACP 3FEFB000, 00F4 (r3 APPLE   Apple00       A5 
Loki       5F)
[    0.000000] ACPI: DSDT 3FEF0000, 48D1 (r1 APPLE  MacBookP    20002 
INTL 20050309)
[    0.000000] ACPI: FACS 3FEC0000, 0040
[    0.000000] ACPI: HPET 3FEFA000, 0038 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: APIC 3FEF9000, 0068 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: MCFG 3FEF8000, 003C (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: ASF! 3FEF7000, 00A0 (r32 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: SBST 3FEF6000, 0030 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: ECDT 3FEF5000, 0053 (r1 APPLE   Apple00        1 
Loki       5F)
[    0.000000] ACPI: SSDT 3FEEF000, 04DC (r1 APPLE     CpuPm     3000 
INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBD000, 064F (r1 SataRe  SataPri     1000 
INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBC000, 069C (r1 SataRe  SataSec     1000 
INTL 20050309)
[    0.000000] ACPI: Local APIC address 0xfee00000


My main concern is making sure
the machine is going to be O.K.
when in this state, or should I revert
to a stable kernel(2.6.28) until things get
worked out?

regards;

Justin P. Mattock
