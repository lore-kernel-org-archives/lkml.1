Return-Path: <linux-kernel-owner+w=401wt.eu-S1755801AbZC3OmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbZC3OmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbZC3Ol7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:41:59 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:45474 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZC3Ol6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:41:58 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2009 10:41:58 EDT
Date: Mon, 30 Mar 2009 10:37:48 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] slub: scan partial list for free slabs when
 thrashing
In-Reply-To: <alpine.DEB.2.00.0903292243050.15813@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903301033380.13333@qirst.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292243050.15813@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009, David Rientjes wrote:

> Whenever a cpu cache satisfies a fastpath allocation, a fastpath counter
> is incrememted.  This counter is cleared whenever the slowpath is
> invoked.  This tracks how many fastpath allocations the cpu slab has
> fulfilled before it must be refilled.

That adds fastpath overhead and it shows for small objects in your tests.

> A new statistic, /sys/kernel/slab/cache/deferred_partial, indicates how
> many times a partial list was deferred because no slabs could satisfy
> the requisite number of objects for CONFIG_SLUB_STATS kernels.

Interesting approach.

