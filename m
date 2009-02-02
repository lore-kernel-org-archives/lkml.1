Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbZBBPFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbZBBPFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 10:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZBBPFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 10:05:00 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:57287 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752142AbZBBPE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 10:04:59 -0500
Date: Mon, 2 Feb 2009 10:00:04 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <1233565214.17835.13.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0902020955490.1549@qirst.com>
References: <20090121143008.GV24891@wotan.suse.de>  <Pine.LNX.4.64.0901211705570.7020@blonde.anvils>  <84144f020901220201g6bdc2d5maf3395fc8b21fe67@mail.gmail.com>  <Pine.LNX.4.64.0901221239260.21677@blonde.anvils>  <Pine.LNX.4.64.0901231357250.9011@blonde.anvils>
  <1233545923.2604.60.camel@ymzhang> <1233565214.17835.13.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009, Pekka Enberg wrote:

> Hi Yanmin,
>
> On Mon, 2009-02-02 at 11:38 +0800, Zhang, Yanmin wrote:
> > Can we add a checking about free memory page number/percentage in function
> > allocate_slab that we can bypass the first try of alloc_pages when memory
> > is hungry?
>
> If the check isn't too expensive, I don't any reason not to. How would
> you go about checking how much free pages there are, though? Is there
> something in the page allocator that we can use for this?

If the free memory is low then reclaim needs to be run to increase the
free memory. Falling back immediately incurs the overhead of going through
the order 0 queues.

