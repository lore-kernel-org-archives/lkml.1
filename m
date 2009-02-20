Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZBTVyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZBTVyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 16:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbZBTVyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 16:54:08 -0500
Received: from rv-out-0506.google.com ([209.85.198.227]:9299 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977AbZBTVyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 16:54:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WmfH3xRxV58iHJPmbV+dTRFc8zRlWB5o4Xb8HF3YU6xmI7VrQyLLYSoIZvoIp4H6O+
         L7o6pKXNYWkXUJWLGgnlQCGWxpmjvjF/epn4UpfUHmf0OgYZQ8KSxpfbyhA5uCSsDRgY
         0OvBDY/+ucz1MlqxRlcd1cajX7RKLzr6BcZg4=
MIME-Version: 1.0
In-Reply-To: <4998A0D9.9090303@kernel.org>
References: <495C677F.6080707@goop.org> <49810211.9030808@kernel.org>
	 <498CF8DA.30004@goop.org> <498CFD95.5070004@kernel.org>
	 <498E229C.5030205@goop.org> <20090209123711.GK17782@elte.hu>
	 <20090215193655.GA18674@elte.hu> <499891D5.1080804@kernel.org>
	 <20090215224607.GA2653@elte.hu> <4998A0D9.9090303@kernel.org>
Date: Fri, 20 Feb 2009 13:54:05 -0800
X-Google-Sender-Auth: b7f58c126ab3a153
Message-ID: <12c511ca0902201354q738f2f91hd94a5e9826e0696f@mail.gmail.com>
Subject: Re: state of some x86 acpi patches
From: Tony Luck <tony.luck@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 3:10 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Index: linux-2.6/arch/ia64/kernel/acpi.c
> ===================================================================
> --- linux-2.6.orig/arch/ia64/kernel/acpi.c
> +++ linux-2.6/arch/ia64/kernel/acpi.c
> @@ -199,7 +199,7 @@ char *__init __acpi_map_table(unsigned l
>        return __va(phys_addr);
>  }
>
> -char *__init __acpi_unmap_table(unsigned long virt_addr, unsigned long size)
> +void __init __acpi_unmap_table(char *map, unsigned long size)
>  {
>  }

I'm seeing some section mismatch warnings for this function (when building
linux-next tag: next-20090220) as it is called by some non __init functions:

WARNING: vmlinux.o(.text+0x498912): Section mismatch in reference from
the function early_acpi_os_unmap_memory() to the function
.init.text:__acpi_unmap_table()

WARNING: vmlinux.o(.text+0x4989a2): Section mismatch in reference from
the function acpi_os_unmap_memory() to the function
.init.text:__acpi_unmap_table()

Simplest solution would seem to be dropping the "__init" (since the
function is empty, it won't bloat the kernel by much if we don't manage
to free up the memory - just 32 bytes :-)

-Tony
