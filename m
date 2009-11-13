Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZKMJRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZKMJRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbZKMJRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:17:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33086 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbZKMJRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:17:34 -0500
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: GFP_ATOMIC versus GFP_NOWAIT
From: Andi Kleen <andi@firstfloor.org>
References: <e9c3a7c20911121728n647ab121l7f7c5827afdac887@mail.gmail.com>
Date: Fri, 13 Nov 2009 10:17:36 +0100
In-Reply-To: <e9c3a7c20911121728n647ab121l7f7c5827afdac887@mail.gmail.com> (Dan Williams's message of "Thu, 12 Nov 2009 18:28:18 -0700")
Message-ID: <87k4xuu6kv.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams <dan.j.williams@intel.com> writes:

> Looking through the tree it seems that almost all drivers that need to
> allocate memory in atomic contexts use GFP_ATOMIC.  I have been asking
> dmaengine device driver authors to switch their atomic allocations to
> GFP_NOWAIT.  The rationale being that in most cases a dma device is
> either offloading an operation that will automatically fallback to
> software when the descriptor allocation fails, or we can simply poll
> and wait for the dma device to release some in use descriptors.  So it
> does not make sense to grab from the emergency pools when the result
> of an allocation failure is some additional cpu overhead.  Am I
> correct in my nagging, and should this idea be spread outside of
> drivers/dma/ to cut down on GFP_ATOMIC usage, or is this not a big
> issue?

It's probably hard to find a good global priority order between
the various allocators, depending on how much the fallback costs. 
But in principle it sounds like a good idea.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
