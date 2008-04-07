Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbYDGIvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbYDGIvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 04:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbYDGIvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 04:51:36 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:44667 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753726AbYDGIvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 04:51:35 -0400
Date: Mon, 7 Apr 2008 17:51:34 +0900
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 24 of 24] xen: add balloon driver
Message-ID: <20080407085134.GD24204%yamahata@valinux.co.jp>
References: <patchbomb.1207158829@localhost> <b3a316a63b9eb9f3eb4c.1207158853@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3a316a63b9eb9f3eb4c.1207158853@localhost>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following modification to include/xen/interface/memory.h 
removes handles related definitions.
It breaks ia64/xen compilation because ia64/xen uses memory interface
not only for balloon, but also for xen_alloc_vm_area/xen_free_vm_area().

Can it be added again?

thanks,

On Wed, Apr 02, 2008 at 10:54:13AM -0700, Jeremy Fitzhardinge wrote:
> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -29,7 +29,7 @@
>       *   OUT: GMFN bases of extents that were allocated
>       *   (NB. This command also updates the mach_to_phys translation table)
>       */
> -    GUEST_HANDLE(ulong) extent_start;
> +    ulong extent_start;
>  
>      /* Number of extents, and size/alignment of each (2^extent_order pages). */
>      unsigned long  nr_extents;
> @@ -50,7 +50,6 @@
>      domid_t        domid;
>  
>  };
> -DEFINE_GUEST_HANDLE_STRUCT(xen_memory_reservation);
>  
>  /*
>   * Returns the maximum machine frame number of mapped RAM in this system.
> @@ -86,7 +85,7 @@
>       * any large discontiguities in the machine address space, 2MB gaps in
>       * the machphys table will be represented by an MFN base of zero.
>       */
> -    GUEST_HANDLE(ulong) extent_start;
> +    ulong extent_start;
>  
>      /*
>       * Number of extents written to the above array. This will be smaller
> @@ -94,7 +93,6 @@
>       */
>      unsigned int nr_extents;
>  };
> -DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mfn_list);
>  
>  /*
>   * Sets the GPFN at which a particular page appears in the specified guest's
> @@ -117,7 +115,6 @@
>      /* GPFN where the source mapping page should appear. */
>      unsigned long gpfn;
>  };
> -DEFINE_GUEST_HANDLE_STRUCT(xen_add_to_physmap);
>  
>  /*
>   * Translates a list of domain-specific GPFNs into MFNs. Returns a -ve error
> @@ -132,14 +129,13 @@
>      unsigned long nr_gpfns;
>  
>      /* List of GPFNs to translate. */
> -    GUEST_HANDLE(ulong) gpfn_list;
> +    ulong gpfn_list;
>  
>      /*
>       * Output list to contain MFN translations. May be the same as the input
>       * list (in which case each input GPFN is overwritten with the output MFN).
>       */
> -    GUEST_HANDLE(ulong) mfn_list;
> +    ulong mfn_list;
>  };
> -DEFINE_GUEST_HANDLE_STRUCT(xen_translate_gpfn_list);
>  
>  #endif /* __XEN_PUBLIC_MEMORY_H__ */
> 
> 
> 

-- 
yamahata
