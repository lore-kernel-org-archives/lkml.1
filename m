Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbYCCUY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbYCCUY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbYCCUYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:24:14 -0500
Received: from mail.suse.de ([195.135.220.2]:44888 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbYCCUYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:24:12 -0500
Date: Mon, 3 Mar 2008 21:24:11 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 2/3] slab: introduce SMP alignment
Message-ID: <20080303202411.GH8974@wotan.suse.de>
References: <20080303093449.GA15091@wotan.suse.de> <20080303093529.GB15091@wotan.suse.de> <Pine.LNX.4.64.0803031104570.6917@schroedinger.engr.sgi.com> <20080303200355.GB8974@wotan.suse.de> <Pine.LNX.4.64.0803031208400.16049@schroedinger.engr.sgi.com> <20080303201211.GE8974@wotan.suse.de> <Pine.LNX.4.64.0803031216430.3110@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803031216430.3110@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 12:17:20PM -0800, Christoph Lameter wrote:
> On Mon, 3 Mar 2008, Nick Piggin wrote:
> 
> > > You want two ways of specifying alignments?
> > 
> > I want a way to ask for SMP friendly allocation.
> 
> Then align the objects at cacheline boundaries by providing a value for 
> the align parameter to kmem_cache_create().

max(num_possible_cpus() > 1 ? cache_line_size() : 0, mandatory_alignment)?

Then suppose we want a CONFIG_TINY option to eliminate it?

max(!CONFIG_TINY && num_possible_cpus() > 1 ? cache_line_size() : 0, mandatory_alignment)

And maybe the VSMP guys will want to blow this out to their internode
alignment?

max(!CONFIG_TINY && num_possible_cpus() > 1 ? (is_vsmp ? internode_alignemnt : cache_line_size()) : 0, mandatory_alignment)


