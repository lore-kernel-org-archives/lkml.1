Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbZANSlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbZANSlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZANSlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:41:05 -0500
Received: from nlpi025.sbcis.sbc.com ([207.115.36.54]:59711 "EHLO
	nlpi025.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZANSlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:41:04 -0500
Date: Wed, 14 Jan 2009 12:40:12 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator
In-Reply-To: <20090114155923.GC1616@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0901141219140.26507@quilx.com>
References: <20090114090449.GE2942@wotan.suse.de>
 <84144f020901140253s72995188vb35a79501c38eaa3@mail.gmail.com>
 <20090114114707.GA24673@wotan.suse.de> <84144f020901140544v56b856a4w80756b90f5b59f26@mail.gmail.com>
 <20090114142200.GB25401@wotan.suse.de> <84144f020901140645o68328e01ne0e10ace47555e19@mail.gmail.com>
 <20090114150900.GC25401@wotan.suse.de> <20090114152207.GD25401@wotan.suse.de>
 <84144f020901140730l747b4e06j41fb8a35daeaf6c8@mail.gmail.com>
 <20090114155923.GC1616@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2009, Nick Piggin wrote:

> Well if you would like to consider SLQB as a fix for SLUB, that's
> fine by me ;) Actually I guess it is a valid way to look at the problem:
> SLQB solves the OLTP regression, so the only question is "what is the
> downside of it?".

The downside is that it brings the SLAB stuff back that SLUB was
designed to avoid. Queue expiration. The use of timers to expire at
uncontrollable intervals for user space. Object dispersal
in the kernel address space. Memory policy handling in the slab
allocator. Even seems to include periodic moving of objects between
queues. The NUMA stuff is still a bit foggy to me since it seems to assume
a mapping between cpus and nodes. There are cpuless nodes as well as
memoryless cpus.

SLQB maybe a good cleanup for SLAB. Its good that it is based on the
cleaned up code in SLUB but the fundamental design is SLAB (or rather the
Solaris allocator from which we got the design for all the queuing stuff
in the first place). It preserves many of the drawbacks of that code.

If SLQB would replace SLAB then there would be a lot of shared code
(debugging for example). Having a generic slab allocator framework may
then be possible within which a variety of algorithms may be implemented.
