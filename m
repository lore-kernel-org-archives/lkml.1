Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZEJTHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZEJTHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 15:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752076AbZEJTHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 15:07:39 -0400
Received: from verein.lst.de ([213.95.11.210]:47643 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbZEJTHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 15:07:38 -0400
Date: Sun, 10 May 2009 21:07:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Steven Rostedt <srostedt@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       cbe-oss-dev@ozlabs.org
Subject: Re: [Cbe-oss-dev] [PATCH, RFC] sputrace: use the generic event tracer
Message-ID: <20090510190705.GA23659@lst.de>
References: <20090506102918.GA23278@lst.de> <20090506105748.GE25203@elte.hu> <20090506165336.GC5997@nowhere> <20090506171326.GA11199@lst.de> <1241636739.11379.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241636739.11379.29.camel@localhost.localdomain>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 03:05:39PM -0400, Steven Rostedt wrote:
> The worry is if this is used by modules. A constant string may not be
> around when the buffer is read.
> 
> This should not be a problem because the formatting of the string is not
> around either, and we just output 'unknown type'.  But I may be adding
> code when a module is unloaded to reset the ring buffer if the module
> registered any events. That's because we have other races to worry
> about.

I think having some constant string description for trace events is
pretty common and used in just above any ad-hoc tracer I've seen,
and just storing the pointers makes this a lot more efficient.

So either we try to make sure this works, or we need some big waivers
in the documentation that people need to use the slower __string
variant.

