Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbYCKOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbYCKOeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 10:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYCKOeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 10:34:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34169 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYCKOeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:34:10 -0400
Subject: Re: [RFC PATCH] Implement slub fastpath with sequence number
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080311093144.GB30220@Krystal>
References: <20080311093144.GB30220@Krystal>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 15:34:03 +0100
Message-Id: <1205246043.8514.188.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 05:31 -0400, Mathieu Desnoyers wrote:
> Here is a new version that works. tested on x86. tweaked the bitmasks
> into unions to remove operations from the critical path, but I tried to
> keep that clean. It applies on vm.git HEAD.
> 
> It allows the cmpxchg_local to detect object re-use by keeping a counter in the
> freeoffset MSBs.
> 
> Whenever an object is freed in the cpu slab cache, the counter is incremented.
> Whenever the alloc/free slow paths are modifying the offset or freebase, the
> sequence counter is also incremented. It is used to make sure we know if
> freebase has been modified in an interrupt nested over the fast path.

Is it (remotely) possible that the version will wrap giving the false
impression that nothing has changed and thus falsely proceed with a
wrong object?

I would really prefer if we defer all this fast path fiddling until we
have the cpu_ops in place, this all just makes the code utterly
unreadable.


