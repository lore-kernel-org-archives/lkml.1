Return-Path: <linux-kernel-owner+w=401wt.eu-S1760582AbYB1Rik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582AbYB1Rik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 12:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYB1Ri3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 12:38:29 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:28939 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYB1Ri2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 12:38:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m5XK+KI5aX1EKLPNwYYdYv85/Pv5ux9Fbc6VBUQbr9uxI19R9HJozhrGAsr87lnCV8sv+9GkFiVdwoae+UPurbKwRJw+p6ZPv91q1ILwOlQc58P0hSQZmnlzguFIS6LhZay6GFlDucxqMDyIAm1V6tjKFs6mL2TocZ+aKa00M+U=
Message-ID: <86802c440802280938j75ebc92eu4104fe76d05e704e@mail.gmail.com>
Date: Thu, 28 Feb 2008 09:38:27 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Alex Riesen" <raa.lkml@gmail.com>, trivial@kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yinghai.lu@sun.com>
Subject: Re: [PATCH] Fix "Malformed early option 'loglevel'"
Cc: "Andi Kleen" <ak@suse.de>
In-Reply-To: <20080228154412.GA4784@steel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080228154412.GA4784@steel.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 7:44 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
> According to Rusty Russell in <1155086871.26428.5.camel@localhost.localdomain>:
>
>     On Tue, 2006-08-08 at 17:10 -0700, Keith Mannthey wrote:
>     > The parameter hotadd_percent is setup right but there is a
>     > "Malformed early option 'numa'" message.
>
>     For the record: this happens when the function registered with
>     early_param() returns non-zero.  __setup() functions return 1 if OK,
>     module_param() and early_param() return 0 or a -ve error code.
>  ---
>
>  For instance:
>
>  Linux version 2.6.25-rc3-t (raa@steel) (gcc version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #22 SMP PREEMPT Tue Feb 26
>  BIOS-provided physical RAM map:
>   BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
>   BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>   BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
>   BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
>   BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
>   BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>  Malformed early option 'loglevel'
>  127MB HIGHMEM available.
>  896MB LOWMEM available.
>
>  Command line:
>
>  BOOT_IMAGE=2.6.25-t ro root=809 ro console=ttyS0,57600n8 console=tty0 loglevel=5
>
>   init/main.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
>  diff --git a/init/main.c b/init/main.c
>  index 8b19820..fbb0167 100644
>  --- a/init/main.c
>  +++ b/init/main.c
>  @@ -254,7 +254,7 @@ early_param("quiet", quiet_kernel);
>   static int __init loglevel(char *str)
>   {
>         get_option(&str, &console_loglevel);
>  -       return 1;
>  +       return 0;
>   }
>
>   early_param("loglevel", loglevel);
>  --
>  1.5.4.3.253.g9f1d5

Acked-by: Yinghai Lu <yhlu.kernel@gmai.com>
