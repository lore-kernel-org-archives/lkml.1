Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbXFXOdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbXFXOdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 10:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXFXOc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 10:32:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:59144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXFXOc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 10:32:57 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
References: <20070624014528.GA17609@wotan.suse.de>
	<20070624014613.GB17609@wotan.suse.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 24 Jun 2007 17:28:39 +0200
In-Reply-To: <20070624014613.GB17609@wotan.suse.de>
Message-ID: <p73fy4h5q3c.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:


[haven't read everything, just commenting on something that caught my eye]

> +struct fsblock {
> +	atomic_t	count;
> +	union {
> +		struct {
> +			unsigned long	flags; /* XXX: flags could be int for better packing */

int is not supported by many architectures, but works on x86 at least.

Hmm, could define a macro DECLARE_ATOMIC_BITMAP(maxbit) that expands to the smallest
possible type for each architecture. And a couple of ugly casts for set_bit et.al.
but those could be also hidden in macros. Should be relatively easy to do.

-Andi
