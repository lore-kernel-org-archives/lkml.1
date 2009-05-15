Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZEOSjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZEOSjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbZEOSix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:38:53 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:53231 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbZEOSiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:38:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w3FpqJjatVYp3fX447RMawcjDzfjfOX8fUkUUyzOuZ27RU9hgCwjCvWtQxJBDk53HQ
         k7FVbDX6U4E5ZxyNJAYvuovNiE3tXvFK/wxxSUzgT7XTxKAD8rmzGvRvjWxU5xV5EF1z
         8vrX58Oe0a/0nWFgSJ4NiFYbxRZ1sUzpjlLLQ=
MIME-Version: 1.0
In-Reply-To: <4A0D8178.4060604@bull.net>
References: <4A0D8178.4060604@bull.net>
Date: Fri, 15 May 2009 11:38:52 -0700
Message-ID: <86802c440905151138t42705477s95a972704db2ce9c@mail.gmail.com>
Subject: Re: SRAT v1 support
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: xb <xavier.bru@bull.net>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, Zoltan <zoltan.menyhart@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 7:51 AM, xb <xavier.bru@bull.net> wrote:
> Recent linux kernels suppose that the  SRAT table is in rev 2 format (ACPI
> 3.0), but some BIOSes still provide SRAT table in rev 1.
> The rev 2 of the SRAT extension mainly provides an extension of the
> "proximity_domain" item from 8 bits to 32 bits, using a "reserved" field of
> the structure.
> When the "reserved" field is not null, linux finds a wrong proximity domain,
> and numa initialization is wrong.
> Following patch tests the SRAT revision to allow a correct initialization:
>
> This patch tests the version of SRAT ACPI table to allow supporting SRAT rev
> 1 and SRAT rev 2.
>
> diff -Nru linux-2.6.29-rc7-orig/arch/x86/kernel/acpi/boot.c
> linux-2.6.29-rc7-tmp/arch/x86/kernel/acpi/boot.c
> --- linux-2.6.29-rc7-orig/arch/x86/kernel/acpi/boot.c    2009-03-12
> 14:41:38.000000000 +0100
> +++ linux-2.6.29-rc7-tmp/arch/x86/kernel/acpi/boot.c    2009-03-16
> 14:52:07.000000000 +0100
> @@ -260,7 +260,8 @@
> }
>
> static int __init
> -acpi_parse_lapic(struct acpi_subtable_header * header, const unsigned long
> end)
> +acpi_parse_lapic(const struct acpi_subtable_header * const header,
> +                const unsigned long end, const int rev)

do we need to pass that rev all over around?

looks like we could use one srat_version or pxm_mask variable to get
the same result.

YH
