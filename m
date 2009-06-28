Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbZF2Cjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbZF2Cjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 22:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZF2Cjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 22:39:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47566 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZF2Cjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 22:39:37 -0400
Date: Mon, 29 Jun 2009 01:24:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/2] exec: Make do_coredump more robust and safer when
	using pipes in core_pattern (v3)
Message-ID: <20090628232445.GA25994@redhat.com>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090629003514.GC2479@localhost.localdomain> <20090628222455.GA21475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090628222455.GA21475@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29, Oleg Nesterov wrote:
>
> But in fact I don't really understand why do we need the new sysctl.

Sorry Neil, I misread the patch. This sysctls limits the number of coredumps
to pipe in flight, not the number of "wait for ->readers == 0".

Agreed, perhaps makes sense. But imho a separate patch is better. And,

> Yes,
> if the collecting process never exits, the coredumping thread can't be reaped.
> But this process runs as root, it can do other bad things. And let's suppose
> it just does nothing, say sleeps forever, and do not read the data from pipe.
> In that case, regardless of any sysctls, ->core_dump() never finishes too.

so I think this core_pipe_limit is more or less orthogonal to "wait for complete".

Oleg.

