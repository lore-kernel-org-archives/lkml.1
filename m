Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbZIUSVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbZIUSVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZIUSVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:21:09 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:56804 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751995AbZIUSVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:21:09 -0400
Date: Mon, 21 Sep 2009 14:17:40 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Mel Gorman <mel@csn.ul.ie>
cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH 0/3] Fix SLQB on memoryless configurations V2
In-Reply-To: <20090921180739.GT12726@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0909211412050.3106@V090114053VZO-1>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie> <20090921174656.GS12726@csn.ul.ie> <alpine.DEB.1.10.0909211349530.3106@V090114053VZO-1> <20090921180739.GT12726@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Sep 2009, Mel Gorman wrote:
> Can you spot if there is something fundamentally wrong with patch 2? I.e. what
> is wrong with treating the closest node as local instead of only the
> closest node?

Depends on the way locking is done for percpu queues (likely lockless).
A misidentification of the numa locality of an object may result in locks
not being taken that should have been taken.

> > Or just allow SLQB for !NUMA configurations and merge it now.
> >
>
> Forcing SLQB !NUMA will not rattle out any existing list issues
> unfortunately :(.

But it will make SLQB work right in permitted configurations. The NUMA
issues can then be fixed later upstream.


