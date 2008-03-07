Return-Path: <linux-kernel-owner+w=401wt.eu-S1763043AbYCGT2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763043AbYCGT2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 14:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbYCGT1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 14:27:55 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:20119 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbYCGT1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 14:27:55 -0500
To: Chris Snook <csnook@redhat.com>
Cc: Andrew Buehler <abuehler.kernel@gmail.com>,
       Frederik Deweerdt <deweerdt@free.fr>, belcampo <belcampo@zonnet.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: Hyperthreading performance oddities
References: <47BE9781.3030304@zonnet.nl> <20080222100630.GE5906@slug>
	<47D14526.2070103@gmail.com> <47D192BF.5090501@redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 07 Mar 2008 20:20:32 +0100
In-Reply-To: <47D192BF.5090501@redhat.com>
Message-ID: <87zltae3y7.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Mar 2008 19:14:02.0330 (UTC) FILETIME=[675F53A0:01C88087]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook <csnook@redhat.com> writes:
> 
> Turning on hyperthreading effectively halves the amount of cache
> available for each logical CPU when both are doing work, which can do
> more harm than good.

When the two cores are in the same address space (as in being two
threads of the same process) L1 cache will be shared on P4. I think
for the other cases the cache management is also a little more
sophisticated than a simple split, depending on which HT generation
you're talking about (Intel had at least 4 generations out, each with
improvements over the earlier ones)

BTW your argument would be in theory true also for multi core with
shared L2 or L3, but even there the CPUs tend to be more sophisticated.
e.g. Core2 has a mechanism called "adaptive cache" which allows one
Core to use significantly more of the L2 in some cases.

>  Number-crunching applications that utilize the
> cache effectively generally don't benefit from hyperthreading,
> particularly floating-point-intensive ones.

That sounds like a far too broad over generalization to me.

-Andi (who personally always liked HT)
