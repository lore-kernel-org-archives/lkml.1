Return-Path: <linux-kernel-owner+w=401wt.eu-S1752584AbYLCLKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbYLCLKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLCLJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:09:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:37593 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYLCLJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:09:50 -0500
Date: Wed, 3 Dec 2008 12:20:49 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Clean up namespace in kmap_types.h
Message-ID: <20081203112049.GI6703@one.firstfloor.org>
References: <20081203003620.GA32069@basil.nowhere.org> <200812031140.02338.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812031140.02338.arnd@arndb.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 11:40:01AM +0100, Arnd Bergmann wrote:
> On Wednesday 03 December 2008, Andi Kleen wrote:
> > Clean up namespace in kmap_types.h
> > 
> > During debugging I often use custom "D" macros. But I ran
> > into a name space conflict with kmap_types.h which also defines a D macro.
> > Rename the kmap_types.h one to KMAPD.
> > 
> > No semantical changes.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> The patch looks ok, but it seems wrong to do this only on one architecture,
> because kmap_types.h is mostly identical across all architectures.
> 
> I'm working on patches to consolidate a lot of generic headers, why not
> add this in a generic way and make x86 use that version?

I was hoping that it could be still fixed for 2.6.28. Perhaps
that would be too intrusive that late? That is why I hope
it can be still considered even if it's x86 only.

For .29 I suspect in fact the best way would be to just move it into linux
and use a superset because I don't think it's a big problem to waste 3-4
pages of virtual space for this.

> --- /dev/null
> +++ b/include/asm-generic/kmap_types.h
> @@ -0,0 +1,29 @@
> +#ifndef __ASM_GENERIC_KMAP_TYPES_H
> +#define __ASM_GENERIC_KMAP_TYPES_H

So are you submitting this?

-Andi
