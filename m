Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752808AbYLRTCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbYLRTCQ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 14:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYLRTB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 14:01:57 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:20582 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYLRTB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 14:01:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=WLVmBhKAZQLQcuaZTVaGAr3EIgoPbWh/JKv9PAqpdCkdxE5Qf4UJkt8+0L71hWkiha
         HwGhEvmXYnU5ePeFPtlCmMMb9/BrBiiS7o4+PkuVTynKCkvV4yJLFf985U7AYzU0ZvNq
         rgj+DIjfZn04U85w53Ifnqb+Ipj2esBJkEi1I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: linux-next: Tree for December 17 (Radeon DRM BUG)
Date: Thu, 18 Dec 2008 20:00:41 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rc8-next-20081217; KDE/4.1.3; i686; ; )
Cc: "Kevin Winchester" <kjwinchester@gmail.com>,
        "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Dave Airlie" <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20081217232536.0b18f4a7.sfr@canb.auug.org.au> <494995D7.6090009@gmail.com> <21d7e9970812172247t3d67e6f0waffa99587e2e024b@mail.gmail.com>
In-Reply-To: <21d7e9970812172247t3d67e6f0waffa99587e2e024b@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812182000.41727.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 December 2008, Dave Airlie wrote:
> On Thu, Dec 18, 2008 at 10:14 AM, Kevin Winchester
> <kjwinchester@gmail.com> wrote:
> > Stephen Rothwell wrote:
> >>
> >> Hi all,
> >>
> >>
> >
> > I get the following BUG in the radeon drm code with today's linux-next when
> > I run "startx".  I have not built or tested linux-next in a while, but the
> > problem definitely does not occur in mainline.

[...]

This reminds me that drm tree in linux-next still results in BSOD (Black
Screen Of Death) on starting X for me (as reported on Saturday [1]).

Actually there is more to it as I discovered that my custom X radeon driver
(which is xorg-x11-drv-ati-6.9.0-61.fc10.i386 with "radeon: no need for this
anymore" from radeon-gem-cs change reverted, please see [2] for my previous
monologue) works fine while following stock driver versions:

	xorg-x11-drv-ati-6.8.0-19.fc9.i386
	xorg-x11-drv-ati-6.9.0-61.fc10.i386
	xorg-x11-drv-ati-6.9.0-62.fc10.i386

result in BSOD.  OTOH they all work with next-20081128 (modulo hangs with
fc10 ones when "radeon: no need for this anymore" change is not reverted).

[ BTW xorg-x11-drv-ati-6.9.0-62.fc10.i386 still causes hangs when used with
  non-Fedora kernels and Fedora/kms kernel still has performance problems ]

IOW there are a lot of compatibility issues in recent drm/radeon changes.

Dave, could you please start looking into these problems?  I'm sure that we
all want recent drm changes + kms in 2.6.29 but given tight schedule and the
way things are looking right now I'm quite sceptical...

[1] http://lkml.org/lkml/2008/12/13/76
[2] http://lkml.org/lkml/2008/12/13/77

Thanks,
Bart
