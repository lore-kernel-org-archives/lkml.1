Return-Path: <linux-kernel-owner+w=401wt.eu-S1422856AbXCWMs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422856AbXCWMs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 08:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422858AbXCWMs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 08:48:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:1159 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422857AbXCWMs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 08:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=OAQ0QVvHQglWmnTzSgKEtFck86XY4Dg/FISTWJYzxYREqYSHgVRFyOjpbbEVJB5mehOClT/EOvI07BcdDiGkG07LN9GRcf6Vl+0iV4Wx0/n+fxPjzIPt+3KuUpPLGpJh2WElerf1gmlM6o57NeYyA0SPDAAKb3GVzWlP/DJZNZw=
Message-ID: <84144f020703230548g4bd2f8b1y4610bb2886860@mail.gmail.com>
Date: Fri, 23 Mar 2007 14:48:24 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: [RFC] NUMA : could we introduce virt_to_nid() ?
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Christoph Lameter" <christoph@lameter.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070323121512.c287ddef.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070321102231.7288f231.dada1@cosmosbay.com>
	 <84144f020703210521q10ad95d4g760010bd4388c71f@mail.gmail.com>
	 <Pine.LNX.4.64.0703210742080.1573@graphe.net>
	 <Pine.LNX.4.64.0703211740460.19583@sbz-30.cs.Helsinki.FI>
	 <20070321160929.GB25583@one.firstfloor.org>
	 <20070323121512.c287ddef.dada1@cosmosbay.com>
X-Google-Sender-Auth: 6c32315b2ed72fd4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, Eric Dumazet <dada1@cosmosbay.com> wrote:
> Checking Christoph quicklist implementation, I found the same cache miss in
> free() than SLAB has.
>
> /* common implementation *
> int virt_to_nid(const void *addr)
> {
>         struct page *page = virt_to_page(addr);
>         return page_to_nid(page);
> }
>
> On some platforms (x86_64 for example), could we have a better implementation,
> not accessing struct page, but using phys_to_nid() ?

Sounds good to me. At least cache_free_alien() in mm/slab.c to should
be converted to use it.
