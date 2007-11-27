Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbXK0ViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbXK0ViT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758667AbXK0ViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:38:05 -0500
Received: from relay1.sgi.com ([192.48.171.29]:37926 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758588AbXK0ViD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:38:03 -0500
Date: Tue, 27 Nov 2007 13:38:02 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andreas Schwab <schwab@suse.de>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, tony.luck@intel.com
Subject: Re: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for
 per cpu access
In-Reply-To: <jeabozs7ou.fsf@sykes.suse.de>
Message-ID: <Pine.LNX.4.64.0711271331240.4803@schroedinger.engr.sgi.com>
References: <20071127001407.859743255@sgi.com> <20071127001430.083503280@sgi.com>
 <jehcj83uir.fsf@sykes.suse.de> <Pine.LNX.4.64.0711271016500.2310@schroedinger.engr.sgi.com>
 <jeabozs7ou.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007, Andreas Schwab wrote:

> Strange.  Works fine here.
> 
> $ arch/ia64/scripts/toolchain-flags gcc objdump readelf
> -DHAVE_WORKING_TEXT_ALIGN -DHAVE_MODEL_SMALL_ATTRIBUTE -DHAVE_SERIALIZE_DIRECTIVE
> $ gcc --version | head -n 1
> gcc (GCC) 4.2.1 (SUSE Linux)
> $ grep ia64_handle_model_attribute config/ia64/*.c
> config/ia64/ia64.c:static tree ia64_handle_model_attribute (tree *, tree, tree, int, bool *);
> config/ia64/ia64.c:  { "model",	       1, 1, true, false, false, ia64_handle_model_attribute },
> config/ia64/ia64.c:ia64_handle_model_attribute (tree *node, tree name, tree args,
> $ grep small_addr_symbolic_operand config/ia64/*.md
> config/ia64/constraints.md:  (match_operand 0 "small_addr_symbolic_operand"))
> config/ia64/predicates.md:(define_predicate "small_addr_symbolic_operand" 

Hmmm...

http://www.ohse.de/uwe/articles/gcc-attributes.html

says:

model (MODEL-NAME)
    Found in versions: 2.8-3.4

But true my compiler still takes it. Ok, I am going to add an option to 
add attributes to percpu definitions.

