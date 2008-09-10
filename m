Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYIJWi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYIJWi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756189AbYIJWin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:38:43 -0400
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:35259 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755763AbYIJWin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:38:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=CjkDNQpIrD2NZ2XEGu0d7NJ5lo74HQ105JXhSUURr1gYrHy7K+ciTvd86Je8asxkoFpAqXfbzWP6Z0BIOF1xZ9uYFWOMAliv3pty8OsugXr17g70+0jTiOVCIlROppm6upf9ebbGx8Uw5K6SwzwIcyNBkUZjZeZR+XmrGba+IDE=  ;
X-YMail-OSG: oDgmGacVM1lwWjrIJfSMj9QW8ErJcPWZIjFWtVT_f8_gNnEuwaod3HDKqi482tkSvwcS3auztqBirw6NoVgpvOXQSzYgA62ZbSVY3aD8cBRPhhBJE6mWfQ5pcEmAhKmB5xJeFWxjdwOLijRvtqJiZA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [Approach #2] [RFC][PATCH] Remove cgroup member from struct page
Date: Thu, 11 Sep 2008 08:38:20 +1000
User-Agent: KMail/1.9.5
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <48C66AF8.5070505@linux.vnet.ibm.com> <20080910012048.GA32752@balbir.in.ibm.com> <1221085260.6781.69.camel@nimitz>
In-Reply-To: <1221085260.6781.69.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809110838.20770.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 September 2008 08:21, Dave Hansen wrote:
> On Tue, 2008-09-09 at 18:20 -0700, Balbir Singh wrote:
> > +       start = pgdat->node_start_pfn;
> > +       end = pgdat->node_start_pfn + pgdat->node_spanned_pages;
> > +       size = (end - start) * sizeof(struct page_cgroup);
> > +       printk("Allocating %lu bytes for node %d\n", size, n);
> > +       pcg_map[n] = alloc_bootmem_node(pgdat, size);
> > +       /*
> > +        * We can do smoother recovery
> > +        */
> > +       BUG_ON(!pcg_map[n]);
> > +       return 0;
> >  }
>
> This will really suck for sparse memory machines.  Imagine a machine
> with 1GB of memory at 0x0 and another 1GB of memory at 1TB up in the
> address space.
>
> You also need to consider how it works with memory hotplug and how
> you're going to grow it at runtime.

I think it should try to hook into the physical memory model
code. I thought it was going to do that but didn't look at the
details...
