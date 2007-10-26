Return-Path: <linux-kernel-owner+w=401wt.eu-S1763870AbXJZVFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763870AbXJZVFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbXJZVFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:05:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:11129 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbXJZVFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:05:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=pw1pob7wwBNkbw1aqVHVCQ5tSv9XFhonQbsFfazvt2NZBOojmWPRlvIE92sDX6DxqcfP6VW5ECzLGwSU7t+qHyGJqU9U++D/1BopAJURwd0em6GZquG2qmwNCf5PWYQ9x4eCtcWK83iiIq17BFKInf2ElXURAN0UIaynkX0WOkw=
From: Matej Laitl <strohel@gmail.com>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: ACPI: use select POWER_SUPPLY for AC, BATTERY and SBS (was: [2.624-rc1 regression] lost battery information)
Date: Fri, 26 Oct 2007 23:05:14 +0200
User-Agent: KMail/1.9.7
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200710262024.06012.arvidjaar@mail.ru> <47221C67.9050502@gmail.com>
In-Reply-To: <47221C67.9050502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710262305.15495.strohel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:
> ACPI: use select POWER_SUPPLY for AC, BATTERY and SBS
>
> From: Alexey Starikovskiy <astarikovskiy@suse.de>
>
> POWER_SUPPLY is needed for AC, battery, and SBS sysfs support.
> Use 'select' instead of 'depends on', as it is will not be selected
> by anything else, leading to confusion.
>
> Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
> ---
>
>  drivers/acpi/Kconfig |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 5d0e26a..ecd87d7 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -88,7 +88,8 @@ config ACPI_PROC_EVENT
>
>  config ACPI_AC
>         tristate "AC Adapter"
> -       depends on X86 && POWER_SUPPLY
> +       depends on X86
> +       select POWER_SUPPLY
>         default y
>         help
>           This driver adds support for the AC Adapter object, which
> indicates @@ -97,7 +98,8 @@ config ACPI_AC
>
>  config ACPI_BATTERY
>         tristate "Battery"
> -       depends on X86 && POWER_SUPPLY
> +       depends on X86
> +       select POWER_SUPPLY
>         default y
>         help
>           This driver adds support for battery information through
> @@ -352,7 +354,7 @@ config ACPI_HOTPLUG_MEMORY
>  config ACPI_SBS
>         tristate "Smart Battery System"
>         depends on X86
> -       depends on POWER_SUPPLY
> +       select POWER_SUPPLY
>         help
>           This driver adds support for the Smart Battery System, another
>           type of access to battery information, found on some laptops.

I'd love if this got merged, as I also lost my battery information by 
not-enabling POWER_SUPPLY (which looks like something unrelated to ACPI). (I 
know "select" is evil, but this use-case is appropriate, IMO)

Matej
