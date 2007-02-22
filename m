Return-Path: <linux-kernel-owner+w=401wt.eu-S1751709AbXBVQyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbXBVQyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXBVQyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:54:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXBVQyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:54:23 -0500
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: SLUB: The unqueued Slab allocator
References: <Pine.LNX.4.64.0702212250271.30485@schroedinger.engr.sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 22 Feb 2007 18:54:06 +0100
In-Reply-To: <Pine.LNX.4.64.0702212250271.30485@schroedinger.engr.sgi.com>
Message-ID: <p73hctecc3l.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> This is a new slab allocator which was motivated by the complexity of the
> with the existing implementation.

Thanks for doing that work. It certainly was long overdue.

> D. SLAB has a complex cache reaper
> 
>    SLUB does not need a cache reaper for UP systems.

This means constructors/destructors are becomming worthless? 
Can you describe your rationale why you think they don't make
sense on UP?

> G. Slab merging
> 
>    We often have slab caches with similar parameters. SLUB detects those
>    on bootup and merges them into the corresponding general caches. This
>    leads to more effective memory use.

Did you do any tests on what that does to long term memory fragmentation?
It is against the "object of same type have similar livetime and should
be clustered together" theory at least.

-Andi
