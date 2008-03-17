Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbYCQHxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbYCQHxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 03:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYCQHxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 03:53:45 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:28979 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYCQHxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 03:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nziA5NU9sYW0tVc4bdXx72VLgFba0A6FU+FdHf1o3zFLq3dFljOhirshHHnDblpns2nWHLA1MGJERFhwj+UHhrYGWgFwsgUvOQtByoYWuL0aqALiYhlIyl/gTHU1dIegIaUZ9hcqNjj36e+MZWm7Joad5BPwCmV5Ho0py7R61bA=
Message-ID: <86802c440803170053n32a1c918h2ff2a32abef44050@mail.gmail.com>
Date: Mon, 17 Mar 2008 00:53:43 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] [11/18] Fix alignment bug in bootmem allocator
Cc: linux-kernel@vger.kernel.org, pj@sgi.com, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au
In-Reply-To: <20080317074146.GG27015@one.firstfloor.org>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 12:41 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > when node_boot_start is 512M alignment, and align is 1024M, offset
>  > could be 512M. it seems
>  > i = ALIGN(i, incr) need to do sth with offset...
>
>  It's possible that there are better fixes for this, but at least
>  my simple patch seems to work here. I admit I was banging my
>  head against this for some time and when I did the fix I just
>  wanted the bug to go away and didn't really go for subtleness.
>
>  The bootmem allocator is quite spaghetti in fact, it could
>  really need some general clean up (although it's' not quite
>  as bad yet as page_alloc.c)

i = ALIGN(i+offset, incr) - offset;

also the one in fail_block...

only happen when align is large than alignment of node_boot_start.

YH
