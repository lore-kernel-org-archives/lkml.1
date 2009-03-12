Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZCLNGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZCLNGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 09:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZCLNGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 09:06:44 -0400
Received: from phunq.net ([64.81.85.152]:37201 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752648AbZCLNGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 09:06:43 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Thu, 12 Mar 2009 06:06:22 -0700
User-Agent: KMail/1.9.9
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903120524.34150.phillips@phunq.net> <20090312123230.GA14425@parisc-linux.org>
In-Reply-To: <20090312123230.GA14425@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903120606.23318.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Matthew Wilcox wrote:
> On Thu, Mar 12, 2009 at 05:24:33AM -0700, Daniel Phillips wrote:
> > On Thursday 12 March 2009, Nick Piggin wrote:
> > > That's interesting. Do you handle 1K block sizes with 64K page size? :)
> > 
> > Not in its current incarnation.  That would require 32 bytes worth of
> > state while the current code just has a 4 byte map (4 bits X 8 blocks).
> > I suppose a reasonable way to extend it would be 4 x 8 byte maps.  Has
> > somebody spotted a 64K page?
> 
> I believe SGI ship their ia64 kernels configured this way.  Certainly
> 16k ia64 kernels are common, which would (if I understand your scheme
> correctly) be 8 bytes worth of state in your scheme.

Yes, correct, and after that the state object would have to expand by a
binary factor, which probably doesn't matter because at that scale it
is really small compared to the blocks it maps.  And the mapped blocks
should just be metadata like index nodes, directory entry blocks and
bitmap blocks, which need per block data handles and locking while
regular file data can work in full pages, which is the same equation
that keeps the pain of buffer_heads down to a dull roar.

Regards,

Daniel


