Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab0BHM6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 07:58:51 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47135 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341Ab0BHM6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 07:58:50 -0500
Subject: Re: [PATCH] kmemcheck: Test the full object in
	kmemcheck_is_obj_initialized()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegardno@ifi.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Casteyde <casteyde.christian@free.fr>
In-Reply-To: <84144f021002080454j2db78133veda0c50a7eff7e6f@mail.gmail.com>
References: <20100208111624.5387.37948.stgit@pc1117.cambridge.arm.com>
	 <84144f021002080454j2db78133veda0c50a7eff7e6f@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 08 Feb 2010 12:58:13 +0000
Message-Id: <1265633893.4020.72.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2010 12:58:14.0226 (UTC) FILETIME=[600DF320:01CAA8BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 12:54 +0000, Pekka Enberg wrote:
> On Mon, Feb 8, 2010 at 1:16 PM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > This is a fix for bug #14845 (bugzilla.kernel.org). The
> > update_checksum() function in mm/kmemleak.c calls
> > kmemcheck_is_obj_initialised() before scanning an object. When
> > KMEMCHECK_PARTIAL_OK is enabled, this function returns true. However,
> > the crc32_le() reads smaller intervals (32-bit) for which
> > kmemleak_is_obj_initialised() may be false leading to a kmemcheck
> > warning.
> >
> > Note that kmemcheck_is_obj_initialized() is currently only used by
> > kmemleak before scanning a memory location.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Christian Casteyde <casteyde.christian@free.fr>
> > Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> > Cc: Vegard Nossum <vegardno@ifi.uio.no>
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Andrew, Vegard has been rather quiet lately so do you mind picking up
> this patch? Alternatively, I can pick it up in slab.git if you so
> prefer.

It's been pretty late indeed, sorry about that (I mostly work on ARM
hardware where kmemcheck isn't available and couldn't test the patch
earlier).

Anyway, IMHO it's not critical to be merged in 2.6.33 but it's up to
you.

Thanks.

-- 
Catalin

