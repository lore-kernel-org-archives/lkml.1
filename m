Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab0CDSgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:36:54 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:56002 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751797Ab0CDSgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:36:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Ut3oerIWDJM2+AHaAOG9PMk0gLeWaCTW39xtdRwLtnXLCP+Mc/oiT4gR6n4puP2/eeekmGbfxLZI7Jwq+wEpyZR3xY1+fPQ+I4vwfhWlsNoNsPftgqxeg537C8x6HFHG;
Date: Thu, 4 Mar 2010 10:36:55 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100304103655.0b14343f@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	<alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010 10:18:03 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> Hmm. What the hell am I supposed to do about
> 
> 	(II) NOUVEAU(0): [drm] nouveau interface version: 0.0.16
> 	(EE) NOUVEAU(0): [drm] wrong version, expecting 0.0.15
> 	(EE) NOUVEAU(0): 879:
> 
> now?
> 
> What happened to the whole backwards compatibility thing? I wasn't even 
> warned that this breaks existing user space. That makes it impossible to 
> _test_ new kernels. Upgrading X and the kernel in lock-step is not a valid 
> model, lots of people are just using some random distribution (F12 in my 
> case), and you just broke it.
> 
> I see the commit that does this was very aware of it:
> 
> 	commit a1606a9596e54da90ad6209071b357a4c1b0fa82
> 	Author: Ben Skeggs <bskeggs@redhat.com>
> 	Date:   Fri Feb 12 10:27:35 2010 +1000
> 
> 	    drm/nouveau: new gem pushbuf interface, bump to 0.0.16
> 
> 	    This commit breaks the userspace interface, and requires a new libdrm for
> 	    nouveau to operate again.
> 
> 	    The multiple GEM_PUSHBUF ioctls that were present in 0.0.15 for
> 	    compatibility purposes are now gone, and replaced with the new ioctl which
> 	    allows for multiple push buffers to be submitted (necessary for hw index
> 	    buffers in the nv50 3d driver) and relocations to be applied on any buffer.
> 
> 	    A number of other ioctls (CARD_INIT, GEM_PIN, GEM_UNPIN) that were needed
> 	    for userspace modesetting have also been removed.
> 
> 	    Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> 	    Signed-off-by: Francisco Jerez <currojerez@riseup.net>
> 
> but why the hell wasn't I made aware of it before-hand? Quite frankly, I 
> probably wouldn't have pulled it.
> 
> We can't just go around breaking peoples setups. This driver is, like it 
> or not, used by Fedora-12 (and probably other distros). It may say 
> "staging", but that doesn't change the fact that it's in production use by 
> huge distributions. Flag days aren't acceptable.

Whoa, so breaking ABI in staging drivers isn't ok?  Lots of other
staging drivers are shipped by distros with compatible userspaces, but I
thought the whole point of staging was to fix up ABIs before they
became mainstream and had backwards compat guarantees, meaning that
breakage was to be expected?

Yes, it sucks, but what else should the nouveau developers have done?
They didn't want to push nouveau into mainline because they weren't
happy with the ABI yet, but it ended up getting pushed anyway as a
staging driver at your request, and now they're stuck?  Sorry this
whole thing is a bit of a wtf...

Yes Dave probably should have mentioned it in his pull request, but
that doesn't seem to be a good reason not to pull imo...

-- 
Jesse Barnes, Intel Open Source Technology Center
