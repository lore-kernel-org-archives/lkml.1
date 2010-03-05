Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab0CEVQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 16:16:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36297 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0CEVQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 16:16:43 -0500
Date: Fri, 5 Mar 2010 21:16:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC PATCH] ARM: Assume new page cache pages have dirty D-cache
Message-ID: <20100305211629.GF4885@n2100.arm.linux.org.uk>
References: <20100304214435.GJ13417@n2100.arm.linux.org.uk> <1267807960.2581.5.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267807960.2581.5.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 04:52:40PM +0000, Catalin Marinas wrote:
> As Ben said, I think we can set PG_dcache_clean in the
> clear/copy_user_page() functions. My doubt with these functions is the
> highmem cases where kunmap_atomic() only flushes the D-cache in one
> situation, the other just calling kunmap_high() which doesn't seem to do
> anything to the caches.

In which case you're totally missing the point with these functions.
The copy_user_page and clear_user_page functions specifically do tricks
to ensure that they can avoid additional cache maintainence - or any
cache maintainence at all.

For instance, on aliasing VIPT, they will map the user page in using
the same colour as the ultimate userspace address, ensuring that any
cache lines created will be visible to the userspace application.

So what kunmap_atomic() does with caches is not really relevant to the
coherency issue.
