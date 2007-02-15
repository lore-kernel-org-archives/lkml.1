Return-Path: <linux-kernel-owner+w=401wt.eu-S932577AbXBOAK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbXBOAK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 19:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932607AbXBOAK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 19:10:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:58399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577AbXBOAK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 19:10:56 -0500
Date: Thu, 15 Feb 2007 01:10:53 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [patch] mm: NUMA replicated pagecache
Message-ID: <20070215001053.GB29797@wotan.suse.de>
References: <20070213060924.GB20644@wotan.suse.de> <Pine.LNX.4.64.0702141057060.975@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702141057060.975@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 11:00:02AM -0800, Christoph Lameter wrote:
> On Tue, 13 Feb 2007, Nick Piggin wrote:
> 
> > This is a scheme for page replication replicates read-only pagecache pages
> > opportunistically, at pagecache lookup time (at points where we know the
> > page is being looked up for read only).
> 
> The problem is that you may only have a single page table. One process 
> with multiple threads will just fault in one thread in order to 
> install the mapping to the page. The others threads may be running on 
> different nodes and different processors but will not generate any 
> faults. Pages will not be replicated as needed. The scheme only seems to 
> be working for special cases of multiple processes mapping the same file.

Yeah like program text, libraries. Not just mapping, also reading, FWIW.

I guess if you map something in different positions, then you can have
it replicated!

But no arguments, this doesn't aim to do replication of the same virtual
address. If you did come up with such a scheme, however, you would still
need a replicated pagecache for it as well.
