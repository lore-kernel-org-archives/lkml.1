Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYK0Bi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYK0Bi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 20:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYK0BiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 20:38:12 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:44135 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYK0BiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 20:38:10 -0500
Date: Wed, 26 Nov 2008 19:37:17 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] fs: Scalability of sockets/pipes allocation/deallocation
 on SMP
In-Reply-To: <492DDB6A.8090806@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0811261935330.31159@quilx.com>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu>
 <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net>
 <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com>
 <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com>
 <20081121153453.GA23713@elte.hu> <492DDB6A.8090806@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008, Eric Dumazet wrote:

> The last point is about SLUB being hit hard, unless we
> use slub_min_order=3 at boot, or we use Christoph Lameter
> patch (struct file RCU optimizations)
> http://thread.gmane.org/gmane.linux.kernel/418615
>
> If we boot machine with slub_min_order=3, SLUB overhead disappears.


I'd rather not be that drastic. Did you try increasing slub_min_objects
instead? Try 40-100. If we find the right number then we should update
the tuning to make sure that it pickes the right slab page sizes.
