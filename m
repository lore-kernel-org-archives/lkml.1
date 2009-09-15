Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbZIOS6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbZIOS6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 14:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbZIOS6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 14:58:17 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43778 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZIOS6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 14:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AsyvSYaJJO0H5p2Os868TvBjbdXr8DzbDdv9FdLOKH6S9QbYKS1dCfspe5VsILyzbY
         E7QOhtZNzWeGzq5LfMl2VIOjTMvHDXXKpWr3Rqx+h+eAPLvZ3CiQYhYqa/rTgaUnnxeM
         fqzeivV1et88A8NDiNYlSgWFMKc4rPwOsyGC4=
MIME-Version: 1.0
In-Reply-To: <1253032210.3273.128.camel@linux-1lbu>
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
	 <20090915103739.GA19519@elf.ucw.cz>
	 <1253017761.3273.117.camel@linux-1lbu>
	 <200909151541.08852.marek.vasut@gmail.com>
	 <1253032210.3273.128.camel@linux-1lbu>
Date: Tue, 15 Sep 2009 21:58:19 +0300
Message-ID: <94a0d4530909151158y489a96e3x63ff932c713822b0@mail.gmail.com>
Subject: Re: [PATCH] arm: remove unused code in delay.S
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Steve Chen <schen@mvista.com>
Cc: Marek Vasut <marek.vasut@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Jamie Lokier <jamie@shareable.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 7:30 PM, Steve Chen <schen@mvista.com> wrote:
> On Tue, 2009-09-15 at 15:41 +0200, Marek Vasut wrote:
>> > -#if 0
>> > +#if CONFIG_OLD_CPU_DELAY
>>
>> ifdef please
>>
> I assume this a vote in favor of considering this patch as an
> alternative :)  The updated patch is below.  Since I'm only summarizing
> the e-mail thread and put them into a patch (which is a less time
> consuming process than continue reading and deleting e-mails on this
> thread), contributors can add signed off before submitting to Russel.
>
> Document #if 0 code block in delay.S and make it selectable for compile.

Nice :)

A few nitpicks though:

> Signed-off-by: Steve Chen <schen@mvista.com>
>
> ---
>
>  arch/arm/Kconfig     |    8 ++++++++
>  arch/arm/lib/delay.S |    2 +-
>  2 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index aef63c8..ca8d535 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -813,6 +813,14 @@ config ARM_ERRATA_460075
>          ACTLR register. Note that setting specific bits in the ACTLR
> register
>          may not be available in non-secure mode.
>
> +config OLD_CPU_DELAY
> +       depends on CPU_32v3 || CPU_32v4 || CPU_32v4T
> +       bool "Accurate delays for older CPU"

s/older CPU/old CPUs/

Or even better, since this option will only appear on older CPUs:
"Accurate delays"

> +       def_bool n
> +       help
> +         Enable if observing longer than expected delays and need more
> +         accurate delays on older CPUs.

How about:
> +         Enable if observing longer than expected delays and need more
> +         accuracy. This should only be considered for old CPUs (e.g. foo, bar).

Cheers.

-- 
Felipe Contreras
