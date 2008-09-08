Return-Path: <linux-kernel-owner+w=401wt.eu-S1753563AbYIHLBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbYIHLBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 07:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYIHLBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 07:01:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60088 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYIHLBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 07:01:44 -0400
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 09/13] genapic: reduce stack pressuge in io_apic.c step 1 temp cpumask_ts
From: Andi Kleen <andi@firstfloor.org>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
	<20080906235038.148283000@polaris-admin.engr.sgi.com>
Date: Mon, 08 Sep 2008 13:01:44 +0200
In-Reply-To: <20080906235038.148283000@polaris-admin.engr.sgi.com> (Mike Travis's message of "Sat, 06 Sep 2008 16:50:45 -0700")
Message-ID: <8763p6vr3b.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis <travis@sgi.com> writes:

>   * Step 1 of cleaning up io_apic.c removes local cpumask_t variables
>     from the stack.

Sorry that patch seems incredibly messy. Global variables
and a tricky ordering and while it's at least commented it's still a mess
and maintenance unfriendly.

Also I think set_affinity is the only case where a truly arbitary cpu
mask can be passed in anyways. And it's passed in from elsewhere. 

The other cases generally just want to handle a subset of CPUs which
are nearby. How about you define a new cpumask like type that 
consists of a start/stop CPU and a mask for that range only 
and is not larger than a few words?

I think with that the nearby assignments could be handled 
reasonably cleanly with arguments and local variables.

And I suspect with some restructuring set_affinity could
be also made to support such a model.

-Andi
