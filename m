Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031AbYLCMAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbYLCMAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYLCL7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:59:50 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:57068 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYLCL7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:59:49 -0500
Date: Wed, 3 Dec 2008 13:01:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: New location for generic headers?
Message-ID: <20081203120110.GA2822@uranus.ravnborg.org>
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

Should we try to get rid of all those silly:
#include <asm-generic/foo.h>
files we have in arch/$ARCH/include/asm?

We could for example add include/generic/ last in the search path.
Or we could add the files in include/asm and add that last in the
search path.

Then if we do not find <asm/foo.h> in arch/$ARCH/include/asm/
then we search include/asm.

Before we can do this we need to get rid of the last users of
include/asm-$ARCH - but we are almost there.
Only m68k seems to require some effort.

	Sam
