Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbZCCWMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbZCCWMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760538AbZCCWID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:08:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58548 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760541AbZCCWIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:08:01 -0500
Date: Tue, 3 Mar 2009 22:07:14 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] generic debug pagealloc
Message-ID: <20090303220713.GC31911@flint.arm.linux.org.uk>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org
References: <20090303160103.GB5812@localhost.localdomain> <20090303133610.cb771fef.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303133610.cb771fef.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 01:36:10PM -0800, Andrew Morton wrote:
> Alternatively, we could just not do the kmap_atomic() at all.  i386
> won't be using this code and IIRC the only other highmem architecture
> is powerpc32, and ppc32 appears to also have its own DEBUG_PAGEALLOC
> implementation.  So you could remove the kmap_atomic() stuff and put

ARM will also be joining the highmem club in due course, maybe during
the next merge window depending on how things pan out.

The biggest issue we have is with kmaps interacting with ARM's DMA API
code.  Nicolas Pitre currently has a work-around for it, but I believe
it can be better handled by extending the generic kmap infrastructure
to be able to grab a reference on an already kmapped page.  I've asked
Nicolas to discuss this aspect of his patch set on lkml.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
