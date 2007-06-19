Return-Path: <linux-kernel-owner+w=401wt.eu-S1759065AbXFSN1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759065AbXFSN1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757560AbXFSN1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:27:03 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32915 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757336AbXFSN1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:27:01 -0400
Date: Tue, 19 Jun 2007 15:27:18 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Denis Cheng <crquan@gmail.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: the memset operation on a automatic array
	variable should be optimized out by data initialization
Message-ID: <20070619132718.GC12950@stusta.de>
References: <467658db.0f98600a.5a55.ffffdd79@mx.google.com> <4676BBC9.3060707@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4676BBC9.3060707@goop.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 10:07:21AM -0700, Jeremy Fitzhardinge wrote:
> Denis Cheng wrote:
> > From: Denis Cheng <crquan@gmail.com>
> >
> > the explicit memset call could be optimized out by data initialization,
> > thus all the fill working can be done by the compiler implicitly.
> 
> How does the generated code change?  Does gcc do something stupid like
> statically allocate a prototype structure full of zeros, and then memcpy
> it in?  Or does it generate a series of explicit assignments for each
> member?  Or does it generate a memset anyway?
> 
> Seems to me that this gives gcc the opportunity to be more stupid, and
> the only right answer is what we're doing anyway.

I checked with gcc 4.2, and gcc is quite clever:

If an array is big, gcc uses memset.
If an array is small, gcc does it directly in assembler.

>     J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

