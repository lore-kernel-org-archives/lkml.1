Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbYHUNnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbYHUNnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 09:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYHUNnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 09:43:04 -0400
Received: from nox.protox.org ([88.191.38.29]:33313 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbYHUNnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 09:43:03 -0400
Date: Thu, 21 Aug 2008 15:42:59 +0200
From: Jerome Glisse <glisse@freedesktop.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Keith Packard <keithp@keithp.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Airlie <airlied@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Message-Id: <20080821154259.a57d8bb6.glisse@freedesktop.org>
In-Reply-To: <200808191150.12345.jbarnes@virtuousgeek.org>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	<200808192000.47070.nickpiggin@yahoo.com.au>
	<1219164367.10772.420.camel@koto.keithp.com>
	<200808191150.12345.jbarnes@virtuousgeek.org>
Organization: freedesktop.org
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 11:50:11 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> As for in-kernel stuff, as long as we keep the GEM shmem hooks separate from 
> the actual bookkeeping (like we do now with i915_gem_create_ioctl() vs 
> drm_gem_object_alloc() for example) we should be able to do the in-kernel 
> stuff w/o jumping through too many VFS/VM hoops.  That would also assume we 
> don't care about swapping in the in-kernel case, which we don't; we want to 
> pin the kernel allocated frame buffer and other memory anyway, so using the 
> internal functions should be fine.

What about suspend to disk ? How do we save such buffers ? 

Btw i think that GTT looks a lot like IOMMU, i don't know the IOMMU kernel
side API that much, but from memory i think that you have call to ask IOMMU
mapping why not do somethings like that for GTT ?

You get normal mapping of object diret but userspace can ask some kind of
GTT mapping on a given object. Anyway new flag on fd sounds good enough too.

Cheers,
Jerome Glisse <glisse@freedesktop.org>
