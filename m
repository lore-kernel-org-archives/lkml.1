Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZGFLy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZGFLy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 07:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbZGFLyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 07:54:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46228 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZGFLyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:54:50 -0400
Date: Mon, 6 Jul 2009 13:54:51 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mitake@dcl.info.waseda.ac.jp, fweisbec@gmail.com, mingo@elte.hu,
       acme@redhat.com, andi@firstfloor.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RFC] Adding information of counts processes acquired how many spinlocks to schedstat
Message-ID: <20090706115451.GA29715@one.firstfloor.org>
References: <20090701110620.GB15958@elte.hu> <20090701.215304.864843820974206197.mitake@dcl.info.waseda.ac.jp> <20090701154450.GC5097@nowhere> <20090706.142058.56800444.mitake@dcl.info.waseda.ac.jp> <1246870279.8143.4.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246870279.8143.4.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe re-use the LOCK_CONTENDED macros for this, but I'm not sure we
> want to go there and put code like this on the lock hot-paths for !debug
> kernels.

My concern was similar.

I suspect it would be in theory ok for the slow spinning path, but I am 
somewhat concerned about the additional cache miss for checking
the global flag even in this case. This could hurt when
the kernel is running fully cache hold, in that the cache miss
might be far more expensive that  short spin.

Needs immediate value patching or just use a jumper kprobe when it's
really needed? I think I would prefer the later variant.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
