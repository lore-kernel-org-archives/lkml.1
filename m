Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYCQSwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYCQSwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYCQSwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:52:46 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:16569 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYCQSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rWFtB/QdSnfBl0BP/OkdcQZ5pR072cG2i8PPlXrfYvhxU7IfKd/ZgR99332aZNJHrfO6Vu/zE/ShyqBgld23Snl6b6ozdV5GMxP+WUZcR3xX0k1TyzL5PVnMKRWvlP2KVxcV8ih/wNGvr+nltmiBekcPm5rkSCdQoOwr727hWvQ=
Message-ID: <86802c440803171152y379560dfp1296aefb0b86b54b@mail.gmail.com>
Date: Mon, 17 Mar 2008 11:52:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] [11/18] Fix alignment bug in bootmem allocator
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
In-Reply-To: <20080317085604.GA12405@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080317258.659191058@firstfloor.org>
	 <20080317015825.0C0171B41E0@basil.firstfloor.org>
	 <86802c440803161919h20ed9f78k6e3798ef56668638@mail.gmail.com>
	 <20080317070208.GC27015@one.firstfloor.org>
	 <86802c440803170017r622114bdpede8625d1a8ff585@mail.gmail.com>
	 <86802c440803170031u75167e5m301f65049b6d62ff@mail.gmail.com>
	 <20080317074146.GG27015@one.firstfloor.org>
	 <86802c440803170053n32a1c918h2ff2a32abef44050@mail.gmail.com>
	 <20080317085604.GA12405@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 1:56 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > only happen when align is large than alignment of node_boot_start.
>
>  Here's an updated version of the patch with this addressed.
>  Please review. The patch is somewhat more complicated, but
>  actually makes the code a little cleaner now.
>
>  -Andi
>
>
>  Fix alignment bug in bootmem allocator
>
>
>  Without this fix bootmem can return unaligned addresses when the start of a
>  node is not aligned to the align value. Needed for reliably allocating
>  gigabyte pages.
>
>  I removed the offset variable because all tests should align themself correctly
>  now. Slight drawback might be that the bootmem allocator will spend
>  some more time skipping bits in the bitmap initially, but that shouldn't
>  be a big issue.
>
>
>  Signed-off-by: Andi Kleen <ak@suse.de>
>
how about create local node_boot_start and node_bootmem_map that make
sure node_boot_start has bigger alignment than align input.

YH
