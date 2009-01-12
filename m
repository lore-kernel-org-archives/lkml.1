Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbZALRZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbZALRZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 12:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbZALRZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 12:25:00 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:57900 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbZALRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 12:24:59 -0500
Date: Mon, 12 Jan 2009 11:23:27 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>, travis@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Biederman <ebiederm@xmission.com>, steiner@sgi.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: regarding the x86_64 zero-based percpu patches
In-Reply-To: <200901101716.04220.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0901121120280.30369@quilx.com>
References: <49649814.4040005@kernel.org> <20090107120225.GA30651@elte.hu>
 <49649C65.6000706@kernel.org> <200901101716.04220.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2009, Rusty Russell wrote:

> > As I was trying to do more stuff per-cpu
> > (not putting a lot of stuff into per-cpu area but even with small
> > things limited per-cpu area poses scalability problems), cpu_alloc
> > seems to fit the bill better.
>
> Unfortunately cpu_alloc didn't solve this problem either.
>
> We need to grow the areas, but for NUMA layouts it's non-trivial.  I don't
> like the idea of remapping: one TLB entry per page per cpu is going to suck.
> Finding pages which are "congruent" with the original percpu pages is more
> promising, but it will almost certainly need to elbow pages out the way to
> have a chance of succeeding on a real system.

An allocation automatically falls back to the nearest node on NUMA
cpu_to_node() gives you the current node.

There are 2M TLB entries on x86_64. If we really get into a high usage
scenario then the 2M entry makes sense. Average server memory sizes likely
already are way beyond 10G per box. The higher that goes the more
reasonable the 2M TLB entry will be.


