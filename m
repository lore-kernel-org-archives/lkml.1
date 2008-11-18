Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbYKRJUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbYKRJUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 04:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYKRJTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 04:19:53 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:34501 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750790AbYKRJTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 04:19:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=22ZEMKuC4FKKoXROy2aCY0HP/CygQbh8kROxphKlUzQuIRjr8QU7E6114MnqB8DblJqSSva55ucVJGTX0q3adaUIwW6/8QmcUIILGIPygl2MRR9PGoMIM1jLFV0P9W/Q8zDT2hpSIFvqD5ZU8fUbUSqaAeUk7WV8GHDuGUtjbNg=  ;
X-YMail-OSG: 5M4mZ74VM1mutrO5YmapeY5PmO91SzWRPbSIay0G2BD5_SkG3xOLdp_dglciZIxrUL10sR3qW8tfOeRcmFLmIDNZDhBbqI8Thz1I1lktysLXveDSD39v1pgXiydEBanuWWc9.73bp775d.vx6MyyY3RgJ7.UodmngmsGiTFX
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH V2 1/4] vmalloc: introduce vfree_atomic()
Date: Tue, 18 Nov 2008 20:19:42 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       David Miller <davem@davemloft.net>, Dave Airlie <airlied@gmail.com>,
       Paul Menage <menage@google.com>, kamezawa.hiroyu@jp.fujitsu.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>, Jan Kara <jack@suse.cz>,
       Jes Sorensen <jes@sgi.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, dada1@cosmosbay.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nick Piggin <npiggin@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Rik van Riel <riel@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>
References: <492162E4.9080902@cn.fujitsu.com> <20081117131440.GB29931@cmpxchg.org> <492281F7.3000107@cn.fujitsu.com>
In-Reply-To: <492281F7.3000107@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811182019.44064.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 November 2008 19:51, Lai Jiangshan wrote:
> fdtable and sysipc use vfree() in RCU callback. this patch
> introduce vfree_atomic() for them.

AFAIKS, vfree is usable from atomic context? What am I missing?
Actually, one could argue that we don't want to perform such
costly operations in the atomic context, however with lazy
unmapping, vfree is very cheap now (amortized, at least).

But it should be much cheaper on average not to schedule this in
another context.

If there was any concern about the TLB flush from atomic context,
we should just defer the lazy flushing, rather than every single
vunmap.
