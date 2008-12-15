Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbYLOVua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbYLOVua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYLOVuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:50:18 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:37267 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbYLOVuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:50:16 -0500
Date: Mon, 15 Dec 2008 22:51:43 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@tungstengraphics.com>
Cc: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>,
       David Airlie <airlied@linux.ie>,
       dri-devel <dri-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: BUG: via_drmclient.h is referenced but does not exist
Message-ID: <20081215215143.GA16475@uranus.ravnborg.org>
References: <20081213193506.GA22969@uranus.ravnborg.org> <49452CEE.1090909@shipmail.org> <20081215210227.GA14396@uranus.ravnborg.org> <4946CB83.2000507@tungstengraphics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4946CB83.2000507@tungstengraphics.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 10:26:27PM +0100, Thomas Hellström wrote:
> Hi!
> 
> Sam Ravnborg wrote:
> >On Sun, Dec 14, 2008 at 04:57:34PM +0100, Thomas Hellström wrote:
> >  
> >>Hi!
> >>
> >>The intention is for via_drm.h to be self-containing when included both 
> >>for a kernel build and for a user-space build. In this particular case, 
> >>via_drmclient.h lives in the user-space clients and includes stdint.h to 
> >>get access to uint32_t and friends.
> >>
> >>Of course, the user-space clients could
> >>#include "uint32.h"
> >>#include "via_drm.h"
> >>
> >>but shouldn't really the tools be mimicing what the compiler does in 
> >>this case?
> >>    
> >
> >The kernel headers and thus the kernel ABI is separate and ideally
> >they should not depend on any other header files to provide anything.
> >
> >This is why __u32, __u64 etc are preferred in the kernel ABI
> >and not uint32_t as used by the drm headers.
> >
> >We do not adhere to this as a strict rule (yet).
> >But if you do:
> >
> >grep -l uint32_t usr/include/linux
> >
> >then you will only see 7 hits. Out of 368 files.
> >So we are not bad in this respect.
> >
> >For drm the fix seems simple - just replace all of uint32_t with __u32.
> >likewise for the other 32 bit and the 64 bit variants.
> >  
> I'm not sure that's possible, as these header files are shared with *BSD 
> (and possibly Solaris).
I dunno about *BSD and solaris.

But other linux ABI header files do:

#include <linux/types.h>

To get access to these basic types.
And we could do the same for drm if the other systems does not prevent it.

	Sam
