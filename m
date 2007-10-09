Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbXJIOxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbXJIOxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXJIOwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:52:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58419 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495AbXJIOww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:52:52 -0400
Date: Tue, 9 Oct 2007 07:52:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: remove zero_page (was Re: -mm merge plans for 2.6.24)
In-Reply-To: <200710090117.47610.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.0.999.0710090750020.5039@woody.linux-foundation.org>
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
 <200710030345.10026.nickpiggin@yahoo.com.au>
 <alpine.LFD.0.999.0710030813090.3579@woody.linux-foundation.org>
 <200710090117.47610.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 9 Oct 2007, Nick Piggin wrote:
> 
> I have done some tests which indicate a couple of very basic common tools
> don't do much zero-page activity (ie. kbuild). And also combined with some
> logical arguments to say that a "sane" app wouldn't be using zero_page much.
> (basically -- if the app cares about memory or cache footprint and is using
> many pages of zeroes, then it should have a more compressed representation
> of zeroes anyway).

One of the things that zero-page has been used for is absolutely *huge* 
(but sparse) arrays in Fortan programs.

At least in traditional fortran, it was very hard to do dynamic 
allocations, so people would allocate the *maximum* array statically, and 
then not necessarily use everything. I don't know if the pages ever even 
got paged in, but this is the kind of usage which is *not* insane.

		Linus
