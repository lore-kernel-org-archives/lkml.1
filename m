Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYDGKIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYDGKIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 06:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756006AbYDGKIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 06:08:45 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:7805 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755977AbYDGKIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 06:08:44 -0400
Message-ID: <47F9F266.4090107@panasas.com>
Date: Mon, 07 Apr 2008 13:07:34 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: Hugh Dickins <hugh@veritas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.ziljstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mpm@selenic.com,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: scsi: fix sense_slab/bio swapping livelock
References: <200804062359.m36Nx3lA016774@hera.kernel.org> <47F9EAD9.3060103@panasas.com> <Pine.LNX.4.64.0804071248110.30814@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0804071248110.30814@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Apr 2008 10:07:40.0212 (UTC) FILETIME=[36835740:01C89897]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07 2008 at 12:52 +0300, Pekka J Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Boaz,
> 
> On Mon, 7 Apr 2008, Boaz Harrosh wrote:
>> The slub behavior described above is disturbing. If I want a 128-byte kmalloc I
>> would use kmalloc. But if I want a dedicated kmem_cache of my own I take the trouble
>> to create one. As I understood it, a dedicated kmem_cache is somewhat growing but
>> lazy-shrinking and eventually maxes out to my usage of it. If I reserve one elemnt then
>> even when memory is low and caches are shrunk I have at least a page. But more then
>> In low memory condition, in a steady sate the cost of each allocation is kept low
>> because I have the pages for my self and I don't need to go grabbing global locks.
>> Sharing with other pools breaks that behavior. Perhaps we need a flag in kmem_cache
>> creation that says we do not want slab sharing (OK slub sharing in this case).
> 
> I think you're better off using the page allocator then. SLOB, for 
> example, doesn't guarantee you're the only user of a page for 
> kmem_cache_alloc() either and I don't really see why it should as it tries 
> to be as memory efficient as possible.
> 
> 		Pekka

Please forgive my ignorance, but what is then the difference between kmem_cache_alloc()
and kmalloc?

would you not agree that sometimes we want to override that sharing of SLOBs?

Boaz
