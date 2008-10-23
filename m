Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbYJWPlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbYJWPlA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYJWPku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:40:50 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:54334 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYJWPkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:40:49 -0400
Date: Thu, 23 Oct 2008 10:39:58 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Miklos Szeredi <miklos@szeredi.hu>,
       nickpiggin@yahoo.com.au, hugh@veritas.com, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: SLUB defrag pull request?
In-Reply-To: <49009575.60004@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0810231035510.17638@quilx.com>
References: <1223883004.31587.15.camel@penberg-laptop> 
 <84144f020810221348j536f0d84vca039ff32676e2cc@mail.gmail.com> 
 <E1Ksksa-0002Iq-EV@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810221416130.26639@quilx.com>
  <E1KsluU-0002R1-Ow@pomaz-ex.szeredi.hu>  <1224745831.25814.21.camel@penberg-laptop>
  <E1KsviY-0003Mq-6M@pomaz-ex.szeredi.hu>  <Pine.LNX.4.64.0810230638450.11924@quilx.com>
  <84144f020810230658o7c6b3651k2d671aab09aa71fb@mail.gmail.com> 
 <Pine.LNX.4.64.0810230705210.12497@quilx.com>
 <84144f020810230714g7f5d36bas812ad691140ee453@mail.gmail.com>
 <Pine.LNX.4.64.0810230721400.12497@quilx.com> <49009575.60004@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2008, Eric Dumazet wrote:

> At alloc time, I remember I added a prefetchw() call in SLAB in 
> __cache_alloc(),
> this could explain some differences between SLUB and SLAB too, since SLAB
> gives a hint to processor to warm its cache.

SLUB touches objects by default when allocating. And it does it 
immediately in slab_alloc() in order to retrieve the pointer to the next 
object. So there is no point of hinting there right now.

If we go to the pointer arrays then the situation is similar to SLAB where 
the object is not touched by the allocator. Then the hint would be useful 
again.

