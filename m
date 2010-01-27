Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007Ab0A0Mnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0A0Mnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796Ab0A0Mna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:43:30 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:62285 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab0A0Mn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:43:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CsACuT/KBNWRVqjVieu5pS/pUfisYO492FgnfkThF1nwLVZEOY4gL7nD7HLbrCYrhx
         FQadFJm667BfFwySfu9B981uqztM7zXdDBcPWZu8aZEFnOjdX1+crs7j8NuIDNuemGS+
         M69/G41c4iFKB9V1UsrMacX6KV8v1FcSREBCU=
MIME-Version: 1.0
In-Reply-To: <1264579476.7187.56.camel@minggr.sh.intel.com>
References: <4B5FE33A.7000201@gmail.com>
	 <efbf743b1001270005v301dbe34ia65b63973e761e8@mail.gmail.com>
	 <1264579476.7187.56.camel@minggr.sh.intel.com>
Date: Wed, 27 Jan 2010 07:43:27 -0500
Message-ID: <a44ae5cd1001270443x31c1e540v9c86263e7ffeeb6c@mail.gmail.com>
Subject: Re: 2.6.33-rc5-git2 -- ACPI Error: Attempt to CreateField of length 
	zero (20091214/dsopcode-529)
From: Miles Lane <miles.lane@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "rui.zhang" <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 3:04 AM, Lin Ming <ming.m.lin@intel.com> wrote:
>
>> From: Miles Lane <miles.lane@gmail.com>
>> Date: Wed, Jan 27, 2010 at 2:54 PM
>> Subject: 2.6.33-rc5-git2 -- ACPI Error: Attempt to CreateField of
>> length zero (20091214/dsopcode-529)
>> To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>, LKML
>> <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
>>
>>
>> I am not sure how much of this is due to a single cause.  Please let
>> me know if you'd like me to send separate reports.
>>
>> ACPI: EC: GPE = 0x1b, I/O: command/status = 0x66, data = 0x62
>> ACPI Warning: Incorrect checksum in table [ATKG] - FA, should be 05
>> (20091214/tbutils-314)
>>
>> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> ACPI Error: Attempt to CreateField of length zero (20091214/dsopcode-529)
>> ACPI Error (psparse-0537): Method parse/execution failed
>> [\_SB_.PCI0.IDE0.RATA] (Node ffff88013f81a9e0), AE_AML_OPERAND_VALUE
>> ACPI Error (psparse-0537): Method parse/execution failed
>> [\_SB_.PCI0.IDE0.PRT1._GTF] (Node ffff88013f81ab20),
>> AE_AML_OPERAND_VALUE
>> ata2.00: _GTF evaluation failed (AE 0x3004)
>> ata2.00: ATAPI: MATSHITADVD-RAM UJ892AS, 1.00, max UDMA/100, ATAPI AN
>> ACPI Error: Attempt to CreateField of length zero (20091214/dsopcode-529)
>> ACPI Error (psparse-0537): Method parse/execution failed
>> [\_SB_.PCI0.IDE0.RATA] (Node ffff88013f81a9e0), AE_AML_OPERAND_VALUE
>> ACPI Error (psparse-0537): Method parse/execution failed
>> [\_SB_.PCI0.IDE0.PRT1._GTF] (Node ffff88013f81ab20),
>> AE_AML_OPERAND_VALUE
>> ata2.00: _GTF evaluation failed (AE 0x3004)
>> ata2.00: configured for UDMA/100
>> scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ892AS  1.00 PQ: 0 ANSI: 5
>>
>
> >From the DSDT,
>
>  2522                 Method (RATA, 1, NotSerialized)
>  2523                 {
>  2524                     CreateByteField (Arg0, Zero, CMDN)
>  2525                     Multiply (CMDN, 0x38, Local0)
>  2526                     CreateField (Arg0, 0x08, Local0, RETB)
>  2527                     Store (RETB, Debug)
>  2528                     Return (RETB)
>  2529                 }
>
>  2546                 Name (ATP1, Buffer (0x32) {})
>  2547                 Device (PRT1)
>  2548                 {
>  2549                     Name (_ADR, 0x0001FFFF)
>  2550                     Method (_SDD, 1, NotSerialized)
>  2551                     {
>  2552                         Store (AGTF (Zero, Arg0), ATP1)
>  2553                     }
>  2554
>  2555                     Method (_GTF, 0, NotSerialized)
>  2556                     {
>  2557                         Return (RATA (ATP1))
>  2558                     }
>  2559                 }
>
> It seems that ATP1 is not set correctly in PRT1._SDD.
> Then ATP1 is passed into RATA and CMDN is created with value zero.
> That causes the error message.

This is the current BIOS for the ASUS UL50VT.  Is this something that gets
fixed by a BIOS update?  Do you have a way to pass this information on to
ASUS?  Is there something the kernel code can do to work around the
problem, or is that already happening?

Thanks,
          Miles
