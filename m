Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbYIIM2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbYIIM2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 08:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYIIM2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 08:28:37 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:36681 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750926AbYIIM2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 08:28:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ePHLAexoNXNBeL+QhxNcnvETtE8IBq0i31VbUoz2HXYPICST0n8oLDH0ojTNV7i3VXMwAS08MkAxKTW4pNzwHRSbUsLTlqNcEp0lazQynBM/CIzJS51ziMmfAKnoPZJqTdAwZmdBK/H2ZWT5XiNC+VL2PtlzsREij0MG2VajKiI=  ;
X-YMail-OSG: E2ymHWoVM1nqspR_NscdO_oHbzfRyzzvS_bT326epNNtfH82utdn7VX3_Ffq6HDRyna99buqzWWJ4GSIptYG8o6zjN1gGgeVqTtkSPLJDztA5Vm1huPCMKwgJwq46CB6f_k-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
Date: Tue, 9 Sep 2008 22:28:18 +1000
User-Agent: KMail/1.9.5
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20080901161927.a1fe5afc.kamezawa.hiroyu@jp.fujitsu.com> <20080909141244.721dfd39.kamezawa.hiroyu@jp.fujitsu.com> <48C66AF8.5070505@linux.vnet.ibm.com>
In-Reply-To: <48C66AF8.5070505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809092228.18680.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2008 22:24, Balbir Singh wrote:
> KAMEZAWA Hiroyuki wrote:

> > Balbir, are you ok to CONFIG_CGROUP_MEM_RES_CTLR depends on
> > CONFIG_SPARSEMEM ? I thinks SPARSEMEM(SPARSEMEM_VMEMMAP) is widely used
> > in various archs now.
>
> Can't we make it more generic. I was thinking of allocating memory for each
> node for page_cgroups (of the size of spanned_pages) at initialization
> time. I've not yet prototyped the idea. BTW, even with your approach I fail
> to see why we need to add a dependency on CONFIG_SPARSEMEM (but again it is
> 4:30 in the morning and I might be missing the obvious)

I guess it would be just a matter of coding up the implementation for
each model you want to support. In some cases, you might lose memory
(eg in the case of flatmem where you have holes in ram), but in those
cases you lose memory from the struct pages anyway so I wouldn't worry
too much.

I think it would be reasonable to provide an implementation for flatmem
as well (which AFAIK is the other non-deprecated memory model). It
should not be hard to code AFAIKS.
