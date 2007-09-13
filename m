Return-Path: <linux-kernel-owner+w=401wt.eu-S1757448AbXIMIr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448AbXIMIr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 04:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbXIMIrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 04:47:18 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:51794 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbXIMIrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 04:47:17 -0400
Date: Thu, 13 Sep 2007 17:47:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Bryan Wu <bryan.wu@analog.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Blackfin arch: add some missing syscall
Message-ID: <20070913084703.GA28094@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Matthew Wilcox <matthew@wil.cx>, Bryan Wu <bryan.wu@analog.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	uclinux-dist-devel@blackfin.uclinux.org, linux-arch@vger.kernel.org
References: <1189670203.30686.15.camel@roc-desktop> <20070913081852.GC17367@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913081852.GC17367@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 02:18:52AM -0600, Matthew Wilcox wrote:
> On Thu, Sep 13, 2007 at 03:56:43PM +0800, Bryan Wu wrote:
> > +/* Not relevant on no-mmu */
> 
> I thought this list seemed a little long, so I investigated a couple
> of them.  mbind makes sense (it's only implemented for NUMA ... a NUMA
> embedded platform?  not the kind which runs applications that use mbind),

There are embedded platforms that are using NUMA memory policies,
including mbind() in applications for setting them. Page migration is a
little iffier, but that can be turned off. Embedded platforms with
multiple memories (and a different cost per memory) are quite common, and
they're getting large enough to offset the overhead of a pgdat + bootmem
map. We have them on nommu also, but that's not been hacked up generically yet.
