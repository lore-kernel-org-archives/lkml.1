Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbZC3MRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbZC3MRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZC3MQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:16:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44854 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZC3MQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:16:53 -0400
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 09/14] fs: use RCU / seqlock logic for reverse and multi-step operaitons
From: Andi Kleen <andi@firstfloor.org>
References: <20090329155539.275927173@nick.local0.net>
	<20090329155749.609663166@nick.local0.net>
Date: Mon, 30 Mar 2009 14:16:49 +0200
In-Reply-To: <20090329155749.609663166@nick.local0.net> (npiggin@suse.de's message of "Mon, 30 Mar 2009 02:55:48 +1100")
Message-ID: <874oxbnr2m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

npiggin@suse.de writes:

> The remaining usages for dcache_lock is to allow atomic, multi-step read-side
> operations over the directory tree by excluding modifications to the tree.
> Also, to walk in the leaf->root direction in the tree where we don't have
> a natural d_lock ordering. This is the hardest bit.

General thoughts: is there a way to add a self testing infrastructure
to this. e.g. by having more sequence counts per object (only enabled
in the debug case, so it doesn't matter when cache line bounces) and lots of 
checks? 

I suppose that would lower the work needed of actually fixing this to 
work significantly.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
