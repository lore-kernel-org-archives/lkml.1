Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbXKLL7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbXKLL7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 06:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbXKLL7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 06:59:08 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:14309 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753144AbXKLL7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 06:59:06 -0500
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/11 v3] enable "make ARCH=x86"
Cc: akpm@linux-foundation.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org
In-reply-To: <20071109230812.GA5176@uranus.ravnborg.org>
References: <20071109230812.GA5176@uranus.ravnborg.org>
Message-Id: <E1IrXwT-0002TP-B4@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Mon, 12 Nov 2007 12:59:01 +0100
X-OriginalArrivalTime: 12 Nov 2007 11:59:01.0796 (UTC) FILETIME=[6A52E640:01C82523]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> With this patchset the former ARCH=i386 / ARCH=x86_64 are
> replaced by ARCH=x86.
[...]
>       x86: drop backward compatibility symlinks to i386/boot and
> 
> The fist kill the symlinks to bzImage.
> Now that we changed everything else to x86 there is no reason to
> keep the backward compatibility symlinks
> It is now people know we are unifying {i386,x86_64}=>x86 so the
> will not be too suprised seeing some breakage.
> If we do not kill the symlinks now - then when..

This was discussed before [1] and the result then was that the symlinks
should be kept for a while (Alan even suggested "a couple of years").
In fact, they were added exactly for that reason.

For one thing, this change is known to break Debian kernel builds using
kernel-package, a method I use myself to build from current git for testing.
I have so far not filed a bug report against kernel-package because there
was still discussion going on as to how things would look and IMO it's
better to change build tools once things have been finalized then trying to
keep up with a moving target.

Breaking kernel-package (and possibly other similar tools) by removing the
compat symlinks too early may mean less testing of kernels by people like me.

Cheers,
Frans Pop

P.S. The ARCH=x86 change would not have broken kernel-package as that could
be worked around using its cross-compilation options. And it currently looks
like the old options will be preserved anyway.

[1] http://lkml.org/lkml/2007/10/26/31
