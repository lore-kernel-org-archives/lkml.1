Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbZCODZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbZCODZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 23:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZCODYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 23:24:53 -0400
Received: from phunq.net ([64.81.85.152]:34062 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750903AbZCODYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 23:24:52 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Tux3] Tux3 report: Tux3 Git tree available
Date: Sat, 14 Mar 2009 20:24:29 -0700
User-Agent: KMail/1.9.9
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-fsdevel@vger.kernel.org,
       tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <200903110925.37614.phillips@phunq.net> <200903130004.40483.nickpiggin@yahoo.com.au> <20090312135940.GB14425@parisc-linux.org>
In-Reply-To: <20090312135940.GB14425@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142024.30142.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Matthew Wilcox wrote:
> On Fri, Mar 13, 2009 at 12:04:40AM +1100, Nick Piggin wrote:
> > As far as the per-block pagecache state (as opposed to the per-block fs
> > state), I don't see any reason it is a problem for efficiency. We have to
> > do per-page operations anyway.
> 
> Why?  Wouldn't it be nice if we could do arbitrary extents?  I suppose
> superpages or soft page sizes get us most of the way there, but the
> rounding or pieces at the end are a bit of a pain.  Sure, it'll be a
> huge upheaval for the VM, but we're good at huge upheavals ;-)

Actually, filesystem extents tend to erode the argument for superpages.
There are three reasons we have seen for wanting big pages: 1) support
larger block buffers without adding messy changes to buffer.c; 2) TLB
efficiency; 3) less per-page state in kernel memory.  TLB efficiency is
only there if the hardware supports it, which X86 arguably doesn't.
The main argument for larger block buffers is less per-block transfer
setup overhead, but the BIO model combined with filesystem extents
does that job better, or at least it will when filesystems learn to
take better advantage of this.

VM extents on the other hand could possibly do a really good job of
reducing per-page VM overhead, if anybody still cares about that now
that 64 bit machines rule the big iron world.

I expect implementing VM extents to be a brutally complex project, as
filesystem extents always turn out to be, even though one tends to
enter such projects thinking, how hard could this be?  Answer: harder
than you think.  But VM extents would be good for a modest speedup, so
somebody is sure to get brave enough to try it sometime.

Regards,

Daniel
