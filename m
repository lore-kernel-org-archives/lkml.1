Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab0BDAIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 19:08:11 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33000 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881Ab0BDAIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 19:08:07 -0500
Date: Thu, 4 Feb 2010 09:07:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       penberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] slub: ARCH_SLAB_MINALIGN defaults to 8 on x86_32. is this too big?
Message-ID: <20100204000755.GA451@linux-sh.org>
References: <1265206946.2118.57.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265206946.2118.57.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 02:22:26PM +0000, Richard Kennedy wrote:
> Can I define a ARCH_SLAB_MINALIGN in x86_64 to sizeof(void *) ? 
> or would it be ok to change the default in slub.c to sizeof(void *) ?
> 
Note that this is precisely what ARCH_SLAB_MINALIGN was introduced to
avoid (BYTES_PER_WORD alignment used to be the default for slab, before
ARCH_SLAB_MINALIGN was introduced). Consider the case of 64-bit platforms
using a 32-bit ABI, the native alignment remains 64-bit while sizeof(void
*) == 4. There are a number of (mainly embedded) architectures that
support these sorts of configurations in-tree.
