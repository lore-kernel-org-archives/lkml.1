Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbZALXTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbZALXTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZALXTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:19:22 -0500
Received: from outbound-mail-102.bluehost.com ([69.89.22.12]:55784 "HELO
	outbound-mail-102.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750948AbZALXTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:19:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=c0NbFUWmIfuuvL2FHy92Na3yAywwh+b9AR6uGrAZ6QJbicXPI9bEgSFeVXEKtLAlIjhOmNX3NvpUm/uQNnJ8nO2WeDOGFoxNwNUhpR3SdVIbHw4qXXPwEgX7SuHD3cG0;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Jan Dittmer" <jdi@l4x.org>
Subject: Re: intel kms "Failed to allocate space for kernel memory manager"
Date: Mon, 12 Jan 2009 15:19:17 -0800
User-Agent: KMail/1.9.10
Cc: "Dave Airlie" <airlied@gmail.com>, "Diego Calleja" <diegocg@gmail.com>,
       linux-kernel@vger.kernel.org, eric.anholt@intel.com, airlied@linux.ie
References: <621d098f0901110546p2b99a525k5de54e37fa181197@mail.gmail.com> <621d098f0901121408y2cf8c2c9y2a6a5cc77ea8e8f5@mail.gmail.com> <621d098f0901121429w6d0792e4g259c8bdbeebc8bdd@mail.gmail.com>
In-Reply-To: <621d098f0901121429w6d0792e4g259c8bdbeebc8bdd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901121519.18693.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 12, 2009 2:29 pm Jan Dittmer wrote:
> On Mon, Jan 12, 2009 at 11:08 PM, Jan Dittmer <jdi@l4x.org> wrote:
> > On Mon, Jan 12, 2009 at 10:53 PM, Jesse Barnes <jbarnes@virtuousgeek.org> 
wrote:
> >>> name of display: :0.0
> >>> libGL: XF86DRIGetClientDriverName: 1.9.0 i965 (screen 0)
> >>> libGL: OpenDriver: trying /usr/local/lib/dri/i965_dri.so
> >>> drmOpenDevice: node name is /dev/dri/card0
> >>> drmOpenDevice: open result is 4, (OK)
> >>> drmOpenByBusid: Searching for BusID pci:0000:00:02.0
> >>> drmOpenDevice: node name is /dev/dri/card0
> >>> drmOpenDevice: open result is 4, (OK)
> >>> drmOpenByBusid: drmOpenMinor returns 4
> >>> drmOpenByBusid: drmGetBusid reports pci:0000:00:02.0
> >>> libGL error: drmMap of framebuffer failed (Resource temporarily
> >>> unavailable) libGL error: reverting to software direct rendering
> >>>
> >>> ?
> >>> This is with latest mesa git libGL. Any special compilation options for
> >>> mesa?
> >>
> >> Nope, not afaik.  Are you sure UXA is enabled?  And that Mesa was built
> >> against the same libdrm bits as your 2D driver?  If so, then I guess
> >> it's time to file a bug. :)
> >
> > With the patches againg 29-rc1 from here
> > http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdif
> >f;h=3a03ac1a0223f779a3de313523408ddb099e5679;hp=dc1336ff4fe08ae7cfe8301bfd
> >7f0b2cfd31d20a and here
> > http://groups.google.com/group/linux.kernel/msg/26aa0471cfb54b06?dmode=so
> >urce&output=gplain at least glxinfo works.
>
> Using drm-intel-next from anholt on top, I've working GL (yeah!) but
> get millions of
> [  649.472172] [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
> counter, -22
> [  649.512429] [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
> counter, -22
> [  649.554513] [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
> counter, -22
> [  649.596972] [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
> counter, -22
> [  649.638744] [drm:drm_wait_vblank] *ERROR* failed to acquire vblank
> counter, -22
>
> entries in my log. libGL says
>
> do_wait: drmWaitVBlank returned -1, IRQs don't seem to be working
> correctly. Try adjusting the vblank_mode configuration parameter.

Those errors indicate that Mesa is trying to wait on a vblank event from a 
disabled pipe.  Interrupts should work fine on the other pipe though 
(assuming you have at least *one* display going! :).

If you can get a backtrace of what's calling this, we should be able to fix 
Mesa to prevent it.

-- 
Jesse Barnes, Intel Open Source Technology Center
