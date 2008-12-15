Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbYLOVBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbYLOVBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYLOVBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:01:05 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:47778 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbYLOVBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:01:04 -0500
Date: Mon, 15 Dec 2008 22:02:27 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: David Airlie <airlied@linux.ie>,
       dri-devel <dri-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: BUG: via_drmclient.h is referenced but does not exist
Message-ID: <20081215210227.GA14396@uranus.ravnborg.org>
References: <20081213193506.GA22969@uranus.ravnborg.org> <49452CEE.1090909@shipmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49452CEE.1090909@shipmail.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2008 at 04:57:34PM +0100, Thomas Hellström wrote:
> Hi!
> 
> The intention is for via_drm.h to be self-containing when included both 
> for a kernel build and for a user-space build. In this particular case, 
> via_drmclient.h lives in the user-space clients and includes stdint.h to 
> get access to uint32_t and friends.
> 
> Of course, the user-space clients could
> #include "uint32.h"
> #include "via_drm.h"
> 
> but shouldn't really the tools be mimicing what the compiler does in 
> this case?

The kernel headers and thus the kernel ABI is separate and ideally
they should not depend on any other header files to provide anything.

This is why __u32, __u64 etc are preferred in the kernel ABI
and not uint32_t as used by the drm headers.

We do not adhere to this as a strict rule (yet).
But if you do:

grep -l uint32_t usr/include/linux

then you will only see 7 hits. Out of 368 files.
So we are not bad in this respect.

For drm the fix seems simple - just replace all of uint32_t with __u32.
likewise for the other 32 bit and the 64 bit variants.

For the specific case where drm includes a non-existing file I suggest
that we get this fixed in some way soon.

	Sam
