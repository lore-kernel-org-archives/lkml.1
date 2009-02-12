Return-Path: <linux-kernel-owner+w=401wt.eu-S1761633AbZBLXiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633AbZBLXiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757612AbZBLXht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:37:49 -0500
Received: from waste.org ([66.93.16.53]:58357 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbZBLXhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:37:48 -0500
Subject: Re: [PATCH] Export symbol ksize()
From: Matt Mackall <mpm@selenic.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
In-Reply-To: <20090212230934.GA21609@gondor.apana.org.au>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
	 <1234435521.28812.165.camel@penberg-laptop>
	 <20090212105034.GC13859@gondor.apana.org.au>
	 <200902130010.46623.nickpiggin@yahoo.com.au>
	 <20090212230934.GA21609@gondor.apana.org.au>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 17:37:01 -0600
Message-Id: <1234481821.3152.27.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-13 at 07:09 +0800, Herbert Xu wrote:
> On Fri, Feb 13, 2009 at 12:10:45AM +1100, Nick Piggin wrote:
> > 
> > I would be interested to know how that goes. You always have this
> > circular issue that if a little more space helps significantly, then
> > maybe it is a good idea to explicitly ask for those bytes. Of course
> > that larger allocation is also likely to have some slack bytes.
> 
> Well, the thing is we don't know apriori whether we need the
> extra space.  The idea is to use the extra space if available
> to avoid reallocation when we hit things like IPsec.

I'm not entirely convinced by this argument. If you're concerned about
space rather than performance, then you want an allocator that doesn't
waste space in the first place and you don't try to do "sub-allocations"
by hand. If you're concerned about performance, you instead optimize
your allocator to be as fast as possible and again avoid conditional
branches for sub-allocations.

-- 
http://selenic.com : development and support for Mercurial and Linux


