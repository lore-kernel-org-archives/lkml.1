Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbZEUAKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbZEUAKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756320AbZEUAKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:10:02 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:58167 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277AbZEUAKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:10:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DpKGmzyyrbcGNjWwvNaa5oazBTsEPoefj2oVl7rokq7RcxpKD5O41enb5gz7dsbyIk
         yzM63o3b4EmDTzQn+D47mJhtZe3uClTj45u7o38cT4+87xio9SjvAaoSoZC4ByZkOs4H
         mGROmukVjVr3H5f4OAcQet98TkK7atswtxHWc=
MIME-Version: 1.0
In-Reply-To: <20090520164910.6939b92b@jbarnes-g45>
References: <49ED22EC.2040204@kernel.org>
	 <200904291708.52830.bjorn.helgaas@hp.com>
	 <200904300914.22772.bjorn.helgaas@hp.com>
	 <200905081640.12677.bjorn.helgaas@hp.com>
	 <20090520164910.6939b92b@jbarnes-g45>
Date: Wed, 20 May 2009 17:10:01 -0700
Message-ID: <86802c440905201710q297ac1ecj4279a780811843b1@mail.gmail.com>
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Gary Hade <garyhade@us.ibm.com>,
       Alex Chiang <achiang@hp.com>, linux-acpi@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20, 2009 at 4:49 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Fri, 8 May 2009 16:40:10 -0600
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>> Did anything happen with this?
>>
>> The longer we wait to make "use_crs" the default, the harder it
>> will be, so I'd like to push ahead.
>
> Here's a patch to make CRS the default.  If it looks ok I can push it
> into my linux-next branch.  I'm all for using reliable data from the
> BIOS.  I guess we'll find out fairly quickly if this stuff isn't...
>
> --
> Jesse Barnes, Intel Open Source Technology Center
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 90b3924..8d798bf 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1777,7 +1777,7 @@ and is between 256 and 4096 characters. It is defined in the file
>                                IRQ routing is enabled.
>                noacpi          [X86] Do not use ACPI for IRQ routing
>                                or for PCI scanning.
> -               use_crs         [X86] Use _CRS for PCI resource
> +               nocrs           [X86] Don't use _CRS for PCI resource
>                                allocation.
>                routeirq        Do IRQ routing for all PCI devices.
>                                This is normally done in pci_enable_device(),
> diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
> index e60fd3e..010c08c 100644
> --- a/arch/x86/include/asm/pci_x86.h
> +++ b/arch/x86/include/asm/pci_x86.h
> @@ -25,7 +25,7 @@
>  #define PCI_BIOS_IRQ_SCAN      0x2000
>  #define PCI_ASSIGN_ALL_BUSSES  0x4000
>  #define PCI_CAN_SKIP_ISA_ALIGN 0x8000
> -#define PCI_USE__CRS           0x10000
> +#define PCI_NO_CRS             0x10000

PCI_NO_ROOT_CRS is more accurate ?

YH
