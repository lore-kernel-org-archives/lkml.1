Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbYCEU44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbYCEU44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 15:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbYCEU4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 15:56:45 -0500
Received: from relay1.sgi.com ([192.48.171.29]:59522 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755267AbYCEU4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 15:56:44 -0500
Date: Wed, 5 Mar 2008 12:56:33 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
In-Reply-To: <20080305002821.GD1510@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803051254570.30742@schroedinger.engr.sgi.com>
References: <20080303093449.GA15091@wotan.suse.de>
 <Pine.LNX.4.64.0803031107130.6917@schroedinger.engr.sgi.com>
 <20080303200613.GC8974@wotan.suse.de> <Pine.LNX.4.64.0803031209570.16049@schroedinger.engr.sgi.com>
 <20080303201701.GF8974@wotan.suse.de> <Pine.LNX.4.64.0803031315160.4131@schroedinger.engr.sgi.com>
 <84144f020803031330i2c0ea1f6kc5b02c8b26145797@mail.gmail.com>
 <Pine.LNX.4.64.0803031331340.4375@schroedinger.engr.sgi.com>
 <47CC6F30.50802@cs.helsinki.fi> <20080305002821.GD1510@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Nick Piggin wrote:

> It started out as a SLUB regression that was exposing poor code in the
> percpu allocator due to different SLUB kmalloc alignments. That prompted

That was due to SLUB's support for smaller allocation sizes. AFAICT has 
nothing to do with alignment.

> The SMP flag was just an RFC. I think some people (like Christoph) were
> being confused about the HWCACHE_ALIGN flag being for avoiding false
> sharing on SMP systems. It would actually be also generally useful to
> have the SMP flag (eg. see the sites I added it to in patch #3).

Hmmm. We could define a global constant for that? Determine it on bootup 
and then pass it as an alignment parameter?
 
