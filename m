Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbZBCROU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbZBCROU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZBCROM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:14:12 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:43943 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbZBCROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:14:11 -0500
Date: Tue, 3 Feb 2009 12:08:43 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, yanmin_zhang@linux.intel.com,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] SLUB: revert direct page allocator pass through
In-Reply-To: <200902031233.40987.nickpiggin@yahoo.com.au>
Message-ID: <alpine.DEB.1.10.0902031159300.26129@qirst.com>
References: <Pine.LNX.4.64.0901231041210.8574@melkki.cs.Helsinki.FI> <200901240317.26227.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0901261206500.32192@qirst.com> <200902031233.40987.nickpiggin@yahoo.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009, Nick Piggin wrote:

> > A bitmap could be
> > used to avoid queuing and may even allow fully concurrent allocations
> > without locks. Use a counter to check watermarks once in a while.
>
> Bitmap? Involving locks or atomic operations, right?

Yes one could use a atomic operation there. The bitmap would be attached
to MAX_ORDER unit and if MAX_ORDER units would be assigned to a cpu for
allocation then the contention would be limited. The only contention would

> The page refcounting layer lives on top of the buddy/queueing/etc layers,
> so the same technique works no matter what the underlying allocator looks
> like.
>
> The only reason I didn't merge it is that it added another branch. I wanted
> to rework the APIs a little bit to avoid it.

Sounds good.

