Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYFTTuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYFTTuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYFTTuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:50:35 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:31437 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYFTTue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JHPkZboC8XImQH+vaakzjf4QKXE3kIgvQkhNHIF2BstqdRmhnBnobmD74ThYk1mZ+L
         9BVoomkjng2mUQEaZ0ph/WsyqWJ4JdiL5+ofbX2jAve3xMdcaiurU832lwWMX9WBq8Pv
         jz8RA+rqGKZyMxWO2FHM6lKIX2CRsHRotohGc=
Message-ID: <86802c440806201250g706bb062t2d472ee0637cac4e@mail.gmail.com>
Date: Fri, 20 Jun 2008 12:50:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: akataria@vmware.com
Subject: Re: [PATCH 1/2] cleanup e820_setup_gap
Cc: "Ingo Molnar" <mingo@elte.hu>, "Brown, Len" <len.brown@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1213990711.31598.22.camel@promb-2n-dhcp368.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213916250.27983.35.camel@promb-2n-dhcp368.eng.vmware.com>
	 <20080620153220.GD17373@elte.hu>
	 <1213990711.31598.22.camel@promb-2n-dhcp368.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 12:38 PM, Alok Kataria <akataria@vmware.com> wrote:
> Here is the patch based on tip/master
>
> Please have a look
>
> --
>
> This is a preparatory patch for the next patch in series.
> Moves some code from e820_setup_gap to a new function e820_search_gap.
> This patch is a part of a bug fix where we walk the ACPI table to calculate
> a gap for PCI optional devices.
>
> Signed-off-by: Alok N Kataria <akataria@vmware.com>
>
> Index: linux-trees.git/arch/x86/kernel/e820.c
> ===================================================================
> --- linux-trees.git.orig/arch/x86/kernel/e820.c 2008-06-20 10:32:44.000000000 -0700
> +++ linux-trees.git/arch/x86/kernel/e820.c      2008-06-20 12:27:58.000000000 -0700
> @@ -442,26 +442,22 @@
>  }
>
>  /*
> - * Search for the biggest gap in the low 32 bits of the e820
> - * memory space.  We pass this space to PCI to assign MMIO resources
> - * for hotplug or unconfigured devices in.
> - * Hopefully the BIOS let enough space left.
> + * Search for a gap in the e820 memory space from start_addr to 2^32.
>  */
> -__init void e820_setup_gap(void)
> +__init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
> +               unsigned long start_addr)
>  {
> -       unsigned long gapstart, gapsize, round;
> -       unsigned long long last;
> -       int i;
> +       unsigned long last = 0x100000000ull;

why changing "unsigned long long" to "unsigned long" ?
it will overflow on 32bit

YH
