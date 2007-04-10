Return-Path: <linux-kernel-owner+w=401wt.eu-S1030310AbXDJCj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030310AbXDJCj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 22:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030314AbXDJCj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 22:39:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:47087 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030310AbXDJCjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 22:39:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19nui4xG+BngraUkiqPZUpmUFHL32rmE9I/Oq6nO1
	nt8IM+n8OP06hu
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <1176097101.6355.89.camel@Homer.simpson.net>
References: <200703290237.38777.kernel@kolivas.org>
	 <20070406100333.GA19855@elte.hu> <200704071650.43905.kernel@kolivas.org>
	 <200704080909.00472.edt@aei.ca>
	 <1176097101.6355.89.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Tue, 10 Apr 2007 04:39:05 +0200
Message-Id: <1176172745.6943.58.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 07:38 +0200, Mike Galbraith wrote:

> I don't think you can have very much effect on latency using nice with
> SD once the CPU is fully utilized.  See below.
> 
> /*
>  * This contains a bitmap for each dynamic priority level with empty slots
>  * for the valid priorities each different nice level can have. It allows
>  * us to stagger the slots where differing priorities run in a way that
>  * keeps latency differences between different nice levels at a minimum.
>  * ie, where 0 means a slot for that priority, priority running from left to
>  * right:
>  * nice -20 0000000000000000000000000000000000000000
>  * nice -10 1001000100100010001001000100010010001000
>  * nice   0 0101010101010101010101010101010101010101
>  * nice   5 1101011010110101101011010110101101011011
>  * nice  10 0110111011011101110110111011101101110111
>  * nice  15 0111110111111011111101111101111110111111
>  * nice  19 1111111111111111111011111111111111111111
>  */
> 
> Nice allocates bandwidth, but as long as the CPU is busy, tasks always
> proceed downward in priority until they hit the expired array.  That's
> the design.

There's another aspect of this that may require some thought - kernel
threads.  As load increases, so does rotation length.  Would you really
want CPU hogs routinely preempting house-keepers under load?

	-Mike

