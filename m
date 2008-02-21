Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbYBUSy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbYBUSy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 13:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755054AbYBUSyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 13:54:47 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:44032 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227AbYBUSyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 13:54:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ntFZrP12Z2tTQjRkasJd8LfMwQs3N7/pn8Dwq1n2SFuwKd2JLbcfFz0xr8QdydzTSLHLc351HSRXjf63GTCrCa6e64Rp5iWHW1wegqoEONi9KT9GvpHH6n5POzvu8w05URYBj1YbDMvD7WTvf42QmoGd1hj5A/y/7ONOn6Thx0E=
Message-ID: <29495f1d0802211054s26665d3cy1609d3347867cb16@mail.gmail.com>
Date: Thu, 21 Feb 2008 10:54:40 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: [BUILD_FAILURE] 2.6.25-rc2-mm1 - Build Failure at acpi_os
Cc: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Andy Whitcroft" <apw@shadowen.org>, sam@ravnborg.org
In-Reply-To: <200802210208.47487.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	 <47B73DD8.4030405@linux.vnet.ibm.com>
	 <200802210208.47487.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/08, Len Brown <lenb@kernel.org> wrote:
> On Saturday 16 February 2008 14:47, Kamalesh Babulal wrote:
>  > Hi Andrew,
>  >
>  > The 2.6.25-rc2-mm1 kernel with randconfig build option, fails
>  > to build on x86_64 machine
>  >
>  >   CC      drivers/acpi/osl.o
>  > drivers/acpi/osl.c:60:38: error: empty filename in #include
>  > drivers/acpi/osl.c: In function 'acpi_os_table_override':
>  > drivers/acpi/osl.c:399: error: 'AmlCode' undeclared (first use in this function)
>  > drivers/acpi/osl.c:399: error: (Each undeclared identifier is reported only once
>  > drivers/acpi/osl.c:399: error: for each function it appears in.)
>  > make[2]: *** [drivers/acpi/osl.o] Error 1
>  > make[1]: *** [drivers/acpi] Error 2
>  > make: *** [drivers] Error 2
>  >
>  > #
>  > # Automatically generated make config: don't edit
>  > # Linux kernel version: 2.6.25-rc2-mm1
>  > # Sun Feb 17 08:07:17 2008
>  > #
>
>
> > CONFIG_ACPI_CUSTOM_DSDT=y
>  > CONFIG_ACPI_CUSTOM_DSDT_FILE=""
>
>
> garbage in, garbage out.

garbage explicitly *allowed* by Kconfig in this case, though.

>  If you don't give this build option a file name where AmlCode lives,
>  then the build will be unable to find AmlCode[].
>
>  http://www.lesswatts.org/projects/acpi/overridingDSDT.php

So we have a .config option whose sole purpose is to use another
.config option? That seems ... less than ideal. Is there not some
Kconfig voodoo we can do to only require the one option? Maybe
something like how CONFIG_INITRAMFS_SOURCE is done? Adding Sam to the
Cc, in case he has any ideas.

Thanks,
Nish
