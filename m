Return-Path: <linux-kernel-owner+w=401wt.eu-S936826AbXGZUkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936826AbXGZUkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935002AbXGZUjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:39:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:44191 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934784AbXGZUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:39:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X39x/tZbx3l75dmpkz/RaHVgAUkAluI9H/P1hgWWbWj3PnWExy+SCPgECmvZLmP+dEJ982qdLwN1DRapl9G+yfk49eMmNujsxwbHepFzztfnxoCVNf853Q8102QJaGMsKObB9u6WYyd4rmk741JUw1IuOaLJPWi5SAZ66GkvtU8=
Message-ID: <86802c440707261339o617cc492v89b3ab2cd9acf553@mail.gmail.com>
Date: Thu, 26 Jul 2007 13:39:47 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 1/5] x86_64: get mp_bus_to_node as early v2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Christoph Lameter" <clameter@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070726201815.GB6387@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440707261305t13bce632r7d82d598b9f8a308@mail.gmail.com>
	 <20070726201815.GB6387@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/07, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Thu, Jul 26, 2007 at 01:05:09PM -0700, Yinghai Lu wrote:
> >
> +#ifdef CONFIG_ACPI_NUMA
>         int pxm;
> -
> -       /* Allocate per-root-bus (not per bus) arch-specific data.
> -        * TODO: leak; this memory is never freed.
> -        * It's arguable whether it's worth the trouble to care.
> -        */
> -       sd = kzalloc(sizeof(*sd), GFP_KERNEL);
> -       if (!sd) {
> -               printk(KERN_ERR "PCI: OOM, not probing PCI bus %02x\n", busnum);
> -               return NULL;
> -       }
> +       int node;
> +#endif
>
>         if (domain != 0) {
>                 printk(KERN_WARNING "PCI: Multiple domains not supported\n");
> -               kfree(sd);
>                 return NULL;
>         }
>
> -       sd->node = -1;
> -
> -       pxm = acpi_get_pxm(device->handle);
>  #ifdef CONFIG_ACPI_NUMA
> -       if (pxm >= 0)
> -               sd->node = pxm_to_node(pxm);
> +       pxm = acpi_get_pxm(device->handle);
> +       if (pxm >= 0) {
> +               node = pxm_to_node(pxm);
> +               printk(KERN_INFO "bus %02x -> pxm %d -> node %02x\n",
> +                       busnum, pxm, node);
> +               set_mp_bus_to_node(busnum, node);
> +       }
>  #endif
> The local variable 'node' is only used in the above if statement.
> So moving the definition inside the if statement will save one pair
> of ugly #ifdef/#endif

yes, that could be move there. but that pair ugly #ifdef/#endif still
need for pxm...

YH
