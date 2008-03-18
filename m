Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYCRCHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYCRCHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 22:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYCRCGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 22:06:52 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:43256 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbYCRCGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 22:06:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xQuKEu1qDp9Gx8ZuntTjwHkAKeDVTDfobNALFVNs7qZY7OH9ofaXcg98VfbWLjFFb0N9qVZ6lOZZSxTc+DYt5z86wk/f2Wf5oWxV0tNLiZ8z/EoqKWhMSu1b+WVlOnVDCKNsb0vN7kRDMX/8eTqEJGYi/8Uu9mhU1Acle7DVSa0=
Message-ID: <86802c440803171906h30e3955bkb02441a99a93f85f@mail.gmail.com>
Date: Mon, 17 Mar 2008 19:06:51 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH] [11/18] Fix alignment bug in bootmem allocator
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
In-Reply-To: <86802c440803171427y7c9b2a54nacb0603916713033@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080317258.659191058@firstfloor.org>
	 <86802c440803161919h20ed9f78k6e3798ef56668638@mail.gmail.com>
	 <20080317070208.GC27015@one.firstfloor.org>
	 <86802c440803170017r622114bdpede8625d1a8ff585@mail.gmail.com>
	 <86802c440803170031u75167e5m301f65049b6d62ff@mail.gmail.com>
	 <20080317074146.GG27015@one.firstfloor.org>
	 <86802c440803170053n32a1c918h2ff2a32abef44050@mail.gmail.com>
	 <20080317085604.GA12405@basil.nowhere.org>
	 <86802c440803171152y379560dfp1296aefb0b86b54b@mail.gmail.com>
	 <86802c440803171427y7c9b2a54nacb0603916713033@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 2:27 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
> On Mon, Mar 17, 2008 at 11:52 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  > On Mon, Mar 17, 2008 at 1:56 AM, Andi Kleen <andi@firstfloor.org> wrote:
>  >  > > only happen when align is large than alignment of node_boot_start.
>  >  >
>  >  >  Here's an updated version of the patch with this addressed.
>  >  >  Please review. The patch is somewhat more complicated, but
>  >  >  actually makes the code a little cleaner now.
>  >  >
>  >  >  -Andi
>  >  >
>  >  >
>  >  >  Fix alignment bug in bootmem allocator
>  >  >
>  >  >
>  >  >  Without this fix bootmem can return unaligned addresses when the start of a
>  >  >  node is not aligned to the align value. Needed for reliably allocating
>  >  >  gigabyte pages.
>  >  >
>  >  >  I removed the offset variable because all tests should align themself correctly
>  >  >  now. Slight drawback might be that the bootmem allocator will spend
>  >  >  some more time skipping bits in the bitmap initially, but that shouldn't
>  >  >  be a big issue.
>  >  >
>  >  >
>  >  >  Signed-off-by: Andi Kleen <ak@suse.de>
>  >  >
>  >  how about create local node_boot_start and node_bootmem_map that make
>  >  sure node_boot_start has bigger alignment than align input.
>
>  please check it
>

please don't use v2... it doesn't work.

YH
