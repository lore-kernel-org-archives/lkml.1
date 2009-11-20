Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZKTSHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZKTSHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbZKTSHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:07:25 -0500
Received: from nox.protox.org ([88.191.38.29]:60285 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbZKTSHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:07:24 -0500
Date: Fri, 20 Nov 2009 19:04:45 +0100
From: Jerome Glisse <glisse@freedesktop.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Jerome Glisse <jglisse@redhat.com>, airlied@gmail.com,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [PATCH 3/3] drm/radeon/kms: Add range pinning to crtc/cursor bo
Message-ID: <20091120180445.GB3467@localhost.localdomain>
References: <1258723764-4399-1-git-send-email-jglisse@redhat.com>
 <1258723764-4399-2-git-send-email-jglisse@redhat.com>
 <1258723764-4399-3-git-send-email-jglisse@redhat.com>
 <1258723764-4399-4-git-send-email-jglisse@redhat.com>
 <a728f9f90911200847g68311ddbx4a5fa652588504ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a728f9f90911200847g68311ddbx4a5fa652588504ab@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 11:47:22AM -0500, Alex Deucher wrote:
> On Fri, Nov 20, 2009 at 8:29 AM, Jerome Glisse <jglisse@redhat.com> wrote:
> > We force the crtc & cursor bo to be in the first 64M, this
> > will help on legacy modesetting hw where the offset of
> > scanout buffer and cursor are relative to a base address.
> 
> This limitation only applies to pre-avivo (r1xx-r4xx) chips, there's
> no need on newer hardware.  Also the cursor and crtc have to be within
> 128 MB of each other, so you could bump the limits to 128 MB.  Another
> thing to consider down the road might be to treat memory over 128 MB
> as "invisible" on these pre-avivo chips (once we support that in
> general) then we no longer need this limit.
> 
> Alex
> 

I choosed 64M in hope to disminish VRAM fragmentation a little,
this is also why i did not bother to make this conditional for
legacy modesetting hw. For supporting non visible vram see my
other ttm thread. I am working on adding this knowledge to ttm.

Cheers,
Jerome
