Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbXFZTE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbXFZTE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757777AbXFZTEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:04:22 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:62115 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695AbXFZTEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J0kSiU0s9lvQU4owemLOs2/EtdSFPMPU8klVSddpcovni5gk4unpRNa5VMhvybqwDlANEZr0QQ16JTXdPoUUEqq+uj/miVOlF1tufDofS9gU5VTLwLdaD7oLDhw/ielkblWXH8POf1TfzRtUG8YIZGODk2et65OgdloijuLYaXw=
Message-ID: <29495f1d0706261204x5b49511co18546443c78033fd@mail.gmail.com>
Date: Tue, 26 Jun 2007 12:04:18 -0700
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] slob: poor man's NUMA support.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Paul Mundt" <lethal@linux-sh.org>, "Matt Mackall" <mpm@selenic.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706261112380.18010@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070619090616.GA23697@linux-sh.org>
	 <20070626002131.ff3518d4.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0706261112380.18010@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/26/07, Christoph Lameter <clameter@sgi.com> wrote:
> On Tue, 26 Jun 2007, Andrew Morton wrote:
>
> > > +#ifdef CONFIG_NUMA
> > > +   if (node != -1)
> > > +           page = alloc_pages_node(node, gfp, order);
> > > +   else
> > > +#endif
> > > +           page = alloc_pages(gfp, order);
> >
> > Isn't the above equivalent to a bare
> >
> >       page = alloc_pages_node(node, gfp, order);
> >
> > ?
>
> No. alloc_pages follows memory policy. alloc_pages_node does not. One of
> the reasons that I want a new memory policy layer are these kinds of
> strange uses.

What would break by changing, in alloc_pages_node()

        if (nid < 0)
                nid = numa_node_id();

to

        if (nid < 0)
                return alloc_pages_current(gfp_mask, order);

beyond needing to make alloc_pages_current() defined if !NUMA too.

Thanks,
Nish
