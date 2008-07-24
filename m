Return-Path: <linux-kernel-owner+w=401wt.eu-S1756424AbYGXLLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbYGXLLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYGXLLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:11:45 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:41822 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752065AbYGXLLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:11:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=53nrfnqJ0SvLsdpPKnoSk2Tekt7AkQULUc5jS08iAzpT5dxr0jC9wCGIt5Oc5WkaezCj8MBI/oHJGqIA0mqdAJpUx8h5RVZauJqI02wOQNS+bGSWFPszRBX/lQ2rZ7nHY/bMy5jiJzwDuR2aITrrifkI4AJr9+xiRS5cNMokJho=  ;
X-YMail-OSG: YgzVX5UVM1kO1Hpu91WOky7KRDsu_BEjnJmE0wKBhuSip4Hegji_EsxHJb5UpvAJ8KgANtkiFxvfZxleHtdAx8CIxfUZoD2mVgh0bBYFHEPZCKeTsK161bPDErNYLKS3tUs-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Sebastien Dugue <sebastien.dugue@bull.net>
Subject: Re: [PATCH 2/2][RT] powerpc - Make the irq reverse mapping radix tree lockless
Date: Thu, 24 Jul 2008 21:11:34 +1000
User-Agent: KMail/1.9.5
Cc: Linux-rt <linux-rt-users@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Tim Chavez <tinytim@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
References: <20080724122352.3bc76bda@bull.net> <20080724125044.53b604cb@bull.net>
In-Reply-To: <20080724125044.53b604cb@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242111.35338.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 20:50, Sebastien Dugue wrote:
> From: Sebastien Dugue <sebastien.dugue@bull.net>
> Date: Tue, 22 Jul 2008 11:56:41 +0200
> Subject: [PATCH][RT] powerpc - Make the irq reverse mapping radix tree
> lockless
>
>   The radix tree used by interrupt controllers for their irq reverse
> mapping (currently only the XICS found on pSeries) have a complex locking
> scheme dating back to before the advent of the concurrent radix tree on
> preempt-rt.
>
>   Take advantage of this and of the fact that the items of the tree are
> pointers to a static array (irq_map) elements which can never go under us
> to simplify the locking.
>
>   Concurrency between readers and writers are handled by the intrinsic
> properties of the concurrent radix tree. Concurrency between the tree
> initialization which is done asynchronously with readers and writers access
> is handled via an atomic variable (revmap_trees_allocated) set when the
> tree has been initialized and checked before any reader or writer access
> just like we used to check for tree.gfp_mask != 0 before.

Hmm, RCU radix tree is in mainline too for quite a while. I thought
Ben had already converted this code over ages ago...

Nothing against the -rt patch, but mainline should probably be updated
to use RCU as well?
