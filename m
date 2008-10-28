Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYJ1LGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYJ1LGg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYJ1LG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:06:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49594 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYJ1LGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:06:24 -0400
Subject: Re: SLUB defrag pull request?
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, nickpiggin@yahoo.com.au,
       hugh@veritas.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <4900B0EF.2000108@cosmosbay.com>
References: <1223883004.31587.15.camel@penberg-laptop>
	 <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com>
	 <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810221416130.26639@quilx.com>
	 <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu>
	 <1224745831.25814.21.camel@penberg-laptop>
	 <E1KsviY-0003Mq-6M@pomaz-ex.szeredi.hu>
	 <Pine.LNX.4.64.0810230638450.11924@quilx.com>
	 <84144f020810230658o7c6b3651k2d671aab09aa71fb@mail.gmail.com>
	 <Pine.LNX.4.64.0810230705210.12497@quilx.com>
	 <84144f020810230714g7f5d36bas812ad691140ee453@mail.gmail.com>
	 <Pine.LNX.4.64.0810230721400.12497@quilx.com>
	 <49009575.60004@cosmosbay.com>
	 <Pine.LNX.4.64.0810231035510.17638@quilx.com>
	 <4900A7C8.9020707@cosmosbay.com>
	 <Pine.LNX.4.64.0810231145430.19239@quilx.com>
	 <4900B0EF.2000108@cosmosbay.com>
Date: Tue, 28 Oct 2008 13:06:23 +0200
Message-Id: <1225191983.27477.16.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-23 at 19:14 +0200, Eric Dumazet wrote:
> [PATCH] slub: slab_alloc() can use prefetchw()
> 
> Most kmalloced() areas are initialized/written right after allocation.
> 
> prefetchw() gives a hint to cpu saying this cache line is going to be
> *modified*, even if first access is a read.
> 
> Some architectures can save some bus transactions, acquiring
> the cache line in an exclusive way instead of shared one.
> 
> Same optimization was done in 2005 on SLAB in commit 
> 34342e863c3143640c031760140d640a06c6a5f8 
> ([PATCH] mm/slab.c: prefetchw the start of new allocated objects)
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Christoph, I was sort of expecting a NAK/ACK from you before merging
this. I would be nice to have numbers on this but then again I don't see
how this can hurt either.

		Pekka

