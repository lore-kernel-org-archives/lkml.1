Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbYCNGdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbYCNGdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 02:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYCNGde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 02:33:34 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56107 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751347AbYCNGde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 02:33:34 -0400
Date: Thu, 13 Mar 2008 23:32:39 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
In-Reply-To: <1205463842.3215.188.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0803132328330.24204@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>  <20080313014808.f8d25c2a.akpm@linux-foundation.org>
  <1205400538.3215.148.camel@ymzhang>  <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
 <1205463842.3215.188.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 14 Mar 2008, Zhang, Yanmin wrote:

> After testing:
> Name                   Objects    Alloc     Free   %Fast
> :0000192                  3428 80093958 80090708  92   8
> :0000512                   374 80016030 80015715  68   7

Ahhh... Okay those slabs did not change for 2.6.25-rc. Is there
really a difference to 2.6.24?

> So block 192 and 512's and very active and their fast free percentage is low.

Yes but that is to be expected given that hackbench does allocate objects 
and then passes them to other processors for freeing.

Could you get me more details on the two critical slabs?

Do slabinfo -a and then pick one alias for each of those sizes.

Then do

slabinfo skbuff_head (whatever alias you want to use to refer to the slab)

for each of them. Should give some more insight as to how slub behaves
with these two slab caches.

