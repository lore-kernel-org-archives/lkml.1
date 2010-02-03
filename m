Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478Ab0BCOWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 09:22:31 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:42692 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756971Ab0BCOWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 09:22:30 -0500
Subject: [RFC] slub: ARCH_SLAB_MINALIGN defaults to 8 on x86_32. is this
 too big?
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Christoph Lameter <cl@linux-foundation.org>,
       penberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Feb 2010 14:22:26 +0000
Message-ID: <1265206946.2118.57.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

slub.c sets the default value of ARCH_SLAB_MINALIGN to sizeof(unsigned
long long) if the architecture didn't already override it.

And as x86_32 doesn't set a value this means that slab objects get
aligned to 8 bytes, potentially wasting 4 bytes per object. Slub forces
objects to be aligned to sizeof(void *) anyway, but I don't see that
there is any need for it to be 8 on 32bits.

I'm working on a patch to pack more buffer_heads into each kmem_cache
slab page.
On 32 bits the structure size is 52 bytes and with the alignment applied
I end up with a slab of 73 x 56 byte objects. However, if the minimum
alignment was sizeof(void *) then I'd get 78 x 52 byte objects. So there
is quite a memory saving to be had in changing this.

Can I define a ARCH_SLAB_MINALIGN in x86_64 to sizeof(void *) ? 
or would it be ok to change the default in slub.c to sizeof(void *) ?

Or am I missing something ?

regards
Richard


