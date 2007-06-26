Return-Path: <linux-kernel-owner+w=401wt.eu-S1757075AbXFZFyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075AbXFZFyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 01:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXFZFyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 01:54:37 -0400
Received: from verein.lst.de ([213.95.11.210]:39919 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbXFZFyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 01:54:35 -0400
Date: Tue, 26 Jun 2007 07:53:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-ia64@vger.kernel.org, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@lst.de>,
       anil.s.keshavamurthy@intel.com, ananth@in.ibm.com
Subject: Re: [PATCH 3/3] Make jprobes a little safer for users
Message-ID: <20070626055347.GB6841@lst.de>
References: <78935473b1f70c863ab0be7d6cf4bcb04922b20b.1182822366.git.michael@ellerman.id.au> <7a070581b2fe53ea65216e86c86abc4f40464341.1182822366.git.michael@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a070581b2fe53ea65216e86c86abc4f40464341.1182822366.git.michael@ellerman.id.au>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 11:48:51AM +1000, Michael Ellerman wrote:
> I realise jprobes are a razor-blades-included type of interface, but
> that doesn't mean we can't try and make them safer to use. This guy I
> know once wrote code like this:
> 
> struct jprobe jp = { .kp.symbol_name = "foo", .entry = "jprobe_foo" };
> 
> And then his kernel exploded. Oops.
> 
> This patch adds an arch hook, arch_deref_entry_point() (I don't like it either)
> which takes the void * in a struct jprobe, and gives back the text address
> that it represents.
> 
> We can then use that in register_jprobe() to check that the entry point
> we're passed is actually in the kernel text, rather than just some random
> value.

Please don't add more weak functions, they're utterly horrible for
anyone trying to understand the code.  Otherwise this looks fine to me.

