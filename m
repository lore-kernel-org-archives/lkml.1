Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbYAWKET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYAWKET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbYAWKEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:04:12 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:20211 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYAWKEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:04:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EisQwEj3kXg4DVs0engNa89GQGmrMbVExn2TyzwCjG/ynmw2OrNOZyv033YqJELuq68F70q1wr+iuTmolXwa3JJrGnL9hjeBxMuIzf9dbD3CKKCzvb4dYxqUmtqGUXROWSt4Ae5AEmy3H/VhDDhG1cKnNsEugHEHjdXWqjTxF00=
Message-ID: <9b06e8d20801230204t4450191eh996a9d45d3ec32a6@mail.gmail.com>
Date: Wed, 23 Jan 2008 11:04:09 +0100
From: "=?ISO-8859-1?Q?Lo=EFc_Greni=E9?=" <loic.grenie@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: vmalloc_32 and SLAB incompatible in 2.6.23.9
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <p73wsq0lw9r.fsf@crumb.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <9b06e8d20801230114v1e09e5e8s6a4b438562c62619@mail.gmail.com>
	 <p73wsq0lw9r.fsf@crumb.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

23 Jan 2008 10:35:28 +0100, Andi Kleen <andi@firstfloor.org>:
> "Loïc Grenié" <loic.grenie@gmail.com> writes:
>
> >      Since GFP_DMA32 is not considered a valid flag, vmalloc_32 and
> >   SLAB are incompatible in kernel 2.6.23.9 (and probably later ones).
> >   It might be as simple as adding GFP_DMA32 everywhere where
> >   GFP_DMA is used in mm/slab.c, but I don't dare do it. I personally
> >   switched to SLUB.
>
> I don't think it would really work for slub either.
>
> If you look at /proc/slabinfo you see that there are separate DMA
> caches. That is because sl[abo]b all cache objects and if the
> objects have different requirements (like GFP_DMA, GFP_DMA32, GFP_KERNEL)
> they would need different caches. Otherwise you risk getting
> later objects originally allocated with the wrong flags.
>
> To make GFP_DMA32 work would require adding another set of DMA32
> caches to all kmalloc caches etc or a separate one for each
> custom kmem cache that you use that only gets _DMA32 objects.
>
> Better just use __get_free_pages() directly.

     vmalloc_32 is using __vmalloc. I am much too ignorant to try and change
  anything in mm/*.[ch]. If vmalloc_32 is incompatible with sl[aou]b, should'nt
  it be either modified or removed ?

        Thanks,

              Loïc Grenié
