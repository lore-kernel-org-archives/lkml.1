Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZGON4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZGON4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZGON4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:56:15 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60843 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbZGON4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:56:14 -0400
Date: Wed, 15 Jul 2009 14:55:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Siarhei Siamashka <siarhei.siamashka@nokia.com>
Cc: ext Jamie Lokier <jamie@shareable.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: copy_page.S: take into account the size of the
	cache line
Message-ID: <20090715135553.GB15533@n2100.arm.linux.org.uk>
References: <1247156605-16245-1-git-send-email-kirill@shutemov.name> <20090710235123.GE30322@shareable.org> <200907151612.20240.siarhei.siamashka@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907151612.20240.siarhei.siamashka@nokia.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 04:12:19PM +0300, Siarhei Siamashka wrote:
> On Saturday 11 July 2009 02:51:23 ext Jamie Lokier wrote:
> > Kirill A. Shutemov wrote:
> > > From: Kirill A. Shutemov <kirill@shutemov.name>
> > >
> > > Optimized version of copy_page() was written with assumption that cache
> > > line size is 32 bytes. On Cortex-A8 cache line size is 64 bytes.
> > >
> > > This patch tries to generalize copy_page() to work with any cache line
> > > size if cache line size is multiple of 16 and page size is multiple of
> > > two cache line size.
> > >
> > > Unfortunately, kernel doesn't provide a macros with correct cache size.
> > > L1_CACHE_SHIFT is 5 on any ARM. So we have to define macros for this
> > > propose by ourself.
> >
> > Why don't you fix L1_CACHE_SHIFT for Cortex-A8?
> 
> That's the plan.

L1_CACHE_SHIFT is supposed to be a constant and the maximum cache line
shift for the processors in use.

Other functions (eg, dma_get_cache_alignment) can return either this or
the real cache line size.
