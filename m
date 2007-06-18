Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbXFRWeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbXFRWeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764362AbXFRWeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:34:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56595 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761479AbXFRWeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:34:07 -0400
Date: Mon, 18 Jun 2007 15:34:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, suresh.b.siddha@intel.com
Subject: Re: [patch 05/26] Slab allocators: Cleanup zeroing allocations
In-Reply-To: <84144f020706181326i6923cccdm21d122ee9eee8fb7@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706181531410.8595@schroedinger.engr.sgi.com>
References: <20070618095838.238615343@sgi.com>  <20070618095914.622685354@sgi.com>
  <84144f020706181316u70145db2i786641d265e5bc42@mail.gmail.com>
 <84144f020706181326i6923cccdm21d122ee9eee8fb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007, Pekka Enberg wrote:

> On 6/18/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > Hmm, did you check kernel text size before and after this change?
> > Setting the __GFP_ZERO flag at every kzalloc call-site seems like a
> > bad idea.
> 
> Aah but most call-sites, of course, use constants such as GFP_KERNEL
> only which should be folded nicely by the compiler. So this probably
> doesn't have much impact. Would be nice if you'd check, though.

IA64

Before:

   text    data     bss     dec     hex filename
10486815        4128471 3686044 18301330        1174192 vmlinux

After:

   text    data     bss     dec     hex filename
10486335        4128439 3686044 18300818        1173f92 vmlinux

Saved ~500 bytes in text size.

x86_64:

Before:

   text    data     bss     dec     hex filename
3823932  333840  220484 4378256  42ce90 vmlinux

After

   text    data     bss     dec     hex filename
3823716  333840  220484 4378040  42cdb8 vmlinux

200 bytes saved.

