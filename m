Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbYCNBjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbYCNBjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 21:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYCNBjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 21:39:36 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:58616 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbYCNBjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 21:39:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Usg3ogfIdo6wZYHM2n0A689dIcJxlCoh2Yb5mEFHGMaJv4Tz3e8hHqhv1a1hMxRT0DKDoqE0opdrg8rr+opl1KZcyv/NY1Ph/piFx6EraPpbow6h/0m7oS/zRuKuexRSvzNyhpIUJqn7SIYQqXacMy4cPA7aaDyl8aGvfQqZCl4=
Message-ID: <86802c440803131839n4f723d14md906a15acb26c3a2@mail.gmail.com>
Date: Thu, 13 Mar 2008 18:39:34 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: make free_bootmem to loop bdata_list
Cc: "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       "Andi Kleen" <ak@suse.de>, "Yasunori Goto" <y-goto@jp.fujitsu.com>
In-Reply-To: <20080314103953.70be95b1.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803131153m325c9e04h43bfd25b667a5c04@mail.gmail.com>
	 <20080314103953.70be95b1.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 6:39 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Thu, 13 Mar 2008 11:53:31 -0700
>  "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>  > ===================================================================
>  > --- linux-2.6.orig/mm/bootmem.c
>  > +++ linux-2.6/mm/bootmem.c
>  > @@ -427,7 +438,9 @@ int __init reserve_bootmem(unsigned long
>  >
>  >  void __init free_bootmem(unsigned long addr, unsigned long size)
>  >  {
>  > -     free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
>  > +     bootmem_data_t *bdata;
>  > +     list_for_each_entry(bdata, &bdata_list, list)
>  > +             free_bootmem_core(bdata, addr, size);
>  >  }
>
>
>  Just a confirmation.
>  In above loop, boundary check in free_bootmem_core() hits two or more times ?
>  If yes, it's ok.
>  If no, please exit loop at hit.

yes. need that handle range cross node (RAMDISK case that is end
beyond end_of_ram).

YH
