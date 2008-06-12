Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbYFLIgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbYFLIgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbYFLIf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:35:59 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:58893 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbYFLIf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:35:58 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: repeatable slab corruption with LTP msgctl08
From: Andi Kleen <andi@firstfloor.org>
References: <20080611221324.42270ef2.akpm@linux-foundation.org>
	<20080611233449.08e6eaa0.akpm@linux-foundation.org>
	<20080612010200.106df621.akpm@linux-foundation.org>
	<20080612011537.6146c41d.akpm@linux-foundation.org>
Date: Thu, 12 Jun 2008 10:35:55 +0200
In-Reply-To: <20080612011537.6146c41d.akpm@linux-foundation.org> (Andrew Morton's message of "Thu, 12 Jun 2008 01:15:37 -0700")
Message-ID: <87mylrnj84.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jun 2008 08:28:43.0225 (UTC) FILETIME=[530E8490:01C8CC66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Doing the same thing on 2.6.26-rc5-mm3, msgctl08 also runs to
> completion, in 20.9 seconds.  So
>
> - it got slower

That is because it scales itself to the number of available msg queues.
So with Nadia's patch there are more and it runs slower.

In fact it seems to start one process per message queue, so perhaps it's 
just running out of processes or something. Ok it should not segfault.

BTW a great way to debug slab corruptions with LTP faster is to run with
a slab thrasher stress module like http://firstfloor.org/~andi/crasher-26.diff

-Andi
