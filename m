Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0CDV1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:27:21 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:49663 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab0CDV1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:27:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GLJ60gUkR+S+MHQSdiym9NQIyIHCOlSd8M0jUEV+qWDyjdktKYgZHfhqlOQbHpunMm
         v9idDeE1zxbqMOmKhpopg6mXMF9dYec7dsIpgQVpBtnx+PLvvWtNwBeg7+rA36sNdVKa
         fLpPP58SzBXl8pwuVjhkTdRevFphO2Lsf4O3k=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
Date: Thu, 4 Mar 2010 22:27:18 +0100
Message-ID: <6d4bc9fc1003041327y2490e365kffaaeec303138558@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Maarten Maathuis <madman2003@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 7:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> Hmm. What the hell am I supposed to do about
>
>        (II) NOUVEAU(0): [drm] nouveau interface version: 0.0.16
>        (EE) NOUVEAU(0): [drm] wrong version, expecting 0.0.15
>        (EE) NOUVEAU(0): 879:
>
> now?

You can update your userspace components. No compatibility is offered
between versions in any direction.

>
> What happened to the whole backwards compatibility thing? I wasn't even
> warned that this breaks existing user space. That makes it impossible to
> _test_ new kernels. Upgrading X and the kernel in lock-step is not a valid
> model, lots of people are just using some random distribution (F12 in my
> case), and you just broke it.
>
> I see the commit that does this was very aware of it:
>
>        commit a1606a9596e54da90ad6209071b357a4c1b0fa82
>        Author: Ben Skeggs <bskeggs@redhat.com>
>        Date:   Fri Feb 12 10:27:35 2010 +1000
>
>            drm/nouveau: new gem pushbuf interface, bump to 0.0.16
>
>            This commit breaks the userspace interface, and requires a new libdrm for
>            nouveau to operate again.
>
>            The multiple GEM_PUSHBUF ioctls that were present in 0.0.15 for
>            compatibility purposes are now gone, and replaced with the new ioctl which
>            allows for multiple push buffers to be submitted (necessary for hw index
>            buffers in the nv50 3d driver) and relocations to be applied on any buffer.
>
>            A number of other ioctls (CARD_INIT, GEM_PIN, GEM_UNPIN) that were needed
>            for userspace modesetting have also been removed.
>
>            Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
>            Signed-off-by: Francisco Jerez <currojerez@riseup.net>
>
> but why the hell wasn't I made aware of it before-hand? Quite frankly, I
> probably wouldn't have pulled it.
>
> We can't just go around breaking peoples setups. This driver is, like it
> or not, used by Fedora-12 (and probably other distros). It may say
> "staging", but that doesn't change the fact that it's in production use by
> huge distributions. Flag days aren't acceptable.
>
>                Linus
>
> ------------------------------------------------------------------------------
> Download Intel&#174; Parallel Studio Eval
> Try the new software tools for yourself. Speed compiling, find bugs
> proactively, and fine-tune applications for parallel performance.
> See why Intel Parallel Studio got high marks during beta.
> http://p.sf.net/sfu/intel-sw-dev
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
