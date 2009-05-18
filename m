Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbZERLTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbZERLTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 07:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZERLTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 07:19:30 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36754 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbZERLT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 07:19:29 -0400
Message-ID: <4A11443C.2010602@bull.net>
Date: Mon, 18 May 2009 13:19:24 +0200
From: xb <xavier.bru@bull.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SRAT v1 support
References: <4A0D8178.4060604@bull.net> <86802c440905151138t42705477s95a972704db2ce9c@mail.gmail.com>
In-Reply-To: <86802c440905151138t42705477s95a972704db2ce9c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yes, could be simpler :-)

    I just saw that Kurt Garloff from Suse has published 3 patches on 
kernel mailing list that fixes the SRAT v1 issue:
    [PATCH 0/3]: Discard reserved PXM bits for SRAT v1
    [PATCH 1/3]: Store SRAT revision
    [PATCH 2/3]: x86-64: Handle SRAT v1 and v2 consistently

    It looks OK for us.

Thanks.
Xavier


Yinghai Lu wrote:
> On Fri, May 15, 2009 at 7:51 AM, xb <xavier.bru@bull.net> wrote:
>   
>> Recent linux kernels suppose that the  SRAT table is in rev 2 format (ACPI
>> 3.0), but some BIOSes still provide SRAT table in rev 1.
>> The rev 2 of the SRAT extension mainly provides an extension of the
>> "proximity_domain" item from 8 bits to 32 bits, using a "reserved" field of
>> the structure.
>> When the "reserved" field is not null, linux finds a wrong proximity domain,
>> and numa initialization is wrong.
>> Following patch tests the SRAT revision to allow a correct initialization:
>>
>> This patch tests the version of SRAT ACPI table to allow supporting SRAT rev
>> 1 and SRAT rev 2.
>>
>> diff -Nru linux-2.6.29-rc7-orig/arch/x86/kernel/acpi/boot.c
>> linux-2.6.29-rc7-tmp/arch/x86/kernel/acpi/boot.c
>> --- linux-2.6.29-rc7-orig/arch/x86/kernel/acpi/boot.c    2009-03-12
>> 14:41:38.000000000 +0100
>> +++ linux-2.6.29-rc7-tmp/arch/x86/kernel/acpi/boot.c    2009-03-16
>> 14:52:07.000000000 +0100
>> @@ -260,7 +260,8 @@
>> }
>>
>> static int __init
>> -acpi_parse_lapic(struct acpi_subtable_header * header, const unsigned long
>> end)
>> +acpi_parse_lapic(const struct acpi_subtable_header * const header,
>> +                const unsigned long end, const int rev)
>>     
>
> do we need to pass that rev all over around?
>
> looks like we could use one srat_version or pxm_mask variable to get
> the same result.
>
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>   
