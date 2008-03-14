Return-Path: <linux-kernel-owner+w=401wt.eu-S1756605AbYCNBER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605AbYCNBER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbYCNBEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:04:09 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:1246 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbYCNBEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RhHfjd2enfKIMCL+cHLf8vPrOuLD/y6DgH+DGRDJtU7y9Su9wXSHO+6eXShPGQLWRGcrTSHEPPvL6zg0BBL18SamyIFUr5/WBa7SjO+0HI7ZYQMRMXVoc0Oy3HrvaFeomb+RXn9QDhAUVDrD0AQrMstE0WAn2cEdiLsL8G1YaaU=
Message-ID: <86802c440803131804w1173b9b5n9d9f2d85c98b8901@mail.gmail.com>
Date: Thu, 13 Mar 2008 18:04:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [PATCH] mm: make reserve_bootmem can crossed the nodes
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Andi Kleen" <ak@suse.de>, "Christoph Lameter" <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <87iqzq40yd.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803131645q1eb31cb7jb0774d9cf67c767@mail.gmail.com>
	 <87iqzq40yd.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 5:13 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Hi,
>
>  "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>

>  >  static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
>  > @@ -407,6 +432,11 @@ unsigned long __init init_bootmem_node(p
>  >  void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
>  >                                unsigned long size, int flags)
>  >  {
>  > +     int ret;
>  > +
>  > +     ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
>  > +     if (ret < 0)
>  > +             return;
>  >       reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
>
>  I don't get it.  Sorry.  What is the purpose of
>  can_reserve_bootmem_core()?  It does exactly what reserve_bootmem_core
>  does besides actually setting the bits.  All the pre-checking you wanted
>  to have out of the way is repeated again in reserve_bootmem_core()
>  (well, almost all).

can_reserve_bootmem_core is check if there is some pages is reserved
already with
>  > +                     if (flags & BOOTMEM_EXCLUSIVE)
>  > +                             return -EBUSY;

so it will avoid the restoring later.

YH
