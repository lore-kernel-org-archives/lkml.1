Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0BOG7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 01:59:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:45686 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab0BOG7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 01:59:21 -0500
Date: Mon, 15 Feb 2010 17:59:14 +1100
From: Nick Piggin <npiggin@suse.de>
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when	__GFP_COLD
 is set"
Message-ID: <20100215065913.GK5723@laptop>
References: <4B4F0E60.1020601@linux.vnet.ibm.com>
 <20100119113306.GA23881@csn.ul.ie>
 <4B6C3E6E.6050303@linux.vnet.ibm.com>
 <20100205174917.GB11512@csn.ul.ie>
 <4B70192C.3070601@linux.vnet.ibm.com>
 <20100208152131.GC23680@csn.ul.ie>
 <4B7184B5.6040400@linux.vnet.ibm.com>
 <20100209175707.GB5098@csn.ul.ie>
 <4B742C2C.5080305@linux.vnet.ibm.com>
 <20100212100519.GA29085@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100212100519.GA29085@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 09:05:19PM +1100, Nick Piggin wrote:
> > This leaves me with two ideas what the real issue could be:
> > 1. either really the 6th parameter as this is the first one that needs to go on stack and that way might open a race and rob gcc a big pile of optimization chances
> 
> It must be something to do wih code generation AFAIKS. I'm surprised
> the function isn't inlined, giving exactly the same result regardless
> of the patch.
> 
> Unlikely to be a correctness issue with code generation, but I'm
> really surprised that a small difference in performance could have
> such a big (and apparently repeatable) effect on behaviour like this.
> 
> What's the assembly look like?

Oh, and what happens if you always_inline it? I would have thought
gcc should be able to generate the same code in both cases -- unless
I'm really missing something and there is a functional change in
there?

