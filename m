Return-Path: <linux-kernel-owner+w=401wt.eu-S965959AbXBOPEo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965959AbXBOPEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 10:04:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965960AbXBOPEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 10:04:44 -0500
Received: from kanga.kvack.org ([66.96.29.28]:60870 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965959AbXBOPEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 10:04:43 -0500
Date: Thu, 15 Feb 2007 13:01:16 -0200
From: Marcelo Tosatti <marcelo@kvack.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Marcelo Tosatti <marcelo@kvack.org>, Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] use movntq version of fast_clear_page/fast_copy_page on Geode
Message-ID: <20070215150116.GA5751@dmt.media.mit.edu>
References: <20070214190839.GA4864@dmt.lan> <20070214211646.74b0ad87@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070214211646.74b0ad87@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 09:16:46PM +0000, Alan wrote:
> On Wed, 14 Feb 2007 17:08:39 -0200
> Marcelo Tosatti <marcelo@kvack.org> wrote:
> 
> > 
> > movntq instruction is supported by Geode CPU's, so use
> > fast_clear_page/fast_copy_page versions that have it.
> 
> Is it actually faster for macro performance not just microbenchmarking ?

A COW intensive private mmap() benchmark shows the kernel spending
_more_ time inside mmx_copy_page() with movntq than with movq.

So its not clear whether the patch is actually a win, please drop it.

