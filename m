Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZGWL2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZGWL2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 07:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZGWL2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 07:28:31 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:49203 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbZGWL2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 07:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OSORLHmsvZXbROP9dFFaLuVzzbJ/CSf1kFFW4+WjX7a6Eq2OHdsCZ339b6NOC0BKYo
         3bQLzcl5e8ACGmn78quaERq9MKqo9+iWsHW6KLuxxeaRokwEOZigQGMqnwl/9+JE179B
         Zx1API5Y91mCXlC3e2u6/TMWl2Ef5QgkWxa5o=
MIME-Version: 1.0
In-Reply-To: <20090723181525.475692d3@feng-desktop>
References: <a4423d670907160148n66760052wbef60e4a2c3c7941@mail.gmail.com>
	 <alpine.LFD.2.00.0907162145140.3531@sony-vgn-z540>
	 <a4423d670907170657o2c68c479j9b4810af5adad29f@mail.gmail.com>
	 <a4423d670907230143l78f324dewefa4cb8990ef4266@mail.gmail.com>
	 <20090723181525.475692d3@feng-desktop>
Date: Thu, 23 Jul 2009 15:28:29 +0400
Message-ID: <a4423d670907230428g48cd2b70wf3d26d2c1378503f@mail.gmail.com>
Subject: Re: next: sfi build fails when !CONFIG_ACPI
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-next <linux-next@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/23 Feng Tang <feng.tang@intel.com>:
> On Thu, 23 Jul 2009 16:43:30 +0800
> Alexander Beregalov <a.beregalov@gmail.com> wrote:
>
>> 2009/7/17 Alexander Beregalov <a.beregalov@gmail.com>:
>> > 2009/7/17 Len Brown <lenb@kernel.org>:
>> >>> drivers/sfi/sfi_core.c: In function 'sfi_init':
>> >>> drivers/sfi/sfi_core.c:346: error: 'acpi_disabled' undeclared
>> >>> (first use in this function)
>> >>> drivers/sfi/sfi_core.c:346: error: (Each undeclared identifier is
>> >>> reported only once
>> >>> drivers/sfi/sfi_core.c:346: error: for each function it appears
>> >>> in.)
>> >>>
>> >>>
>> >>> $ grep ACPI .config
>> >>> # Power management and ACPI options
>> >>
>> >> It builds for me.
>> >> Please send me the complete failing .config
>> >
>> > Attached (x86_64)
>>
>> Still fails for me in the same way,
>> X86_64
>> next-20090723
>
> sorry for the late response, please try the following patch:
It obviously works. Thanks

>
> diff --git a/drivers/sfi/sfi_core.c b/drivers/sfi/sfi_core.c
> index 62e2f98..fa66824 100644
> --- a/drivers/sfi/sfi_core.c
> +++ b/drivers/sfi/sfi_core.c
> @@ -361,9 +361,6 @@ static __init int sfi_find_syst(void)
>
>  void __init sfi_init(void)
>  {
> -       if (!acpi_disabled)
> -               disable_sfi();
> -
>        if (sfi_disabled)
>                return;
>
> Thanks,
> Feng
>
