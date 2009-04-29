Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbZD2LDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbZD2LDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760025AbZD2LCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:02:43 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:34526 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760011AbZD2LCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:02:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PABrrnTRADCAHN8Oz/R42B3T2xNMoJBHBtPp+mYRu4uQHIcYORmwoGdXD8Aq5RtI2J
         nYcWuifPH7xzP07iuCdFJvvbGTukVHg+tDbkX06SUinyFTqH+JL1Uu+U40zRR+fqVGy3
         +BYJiFytdbGTvxHlEsEvMWeuXlyceqY0qir2o=
MIME-Version: 1.0
In-Reply-To: <21d7e9970904290027v1275c346p8a8f29d2fb4658fb@mail.gmail.com>
References: <8563BBE2A1F848B3B98C1A5FAE08BD09@avitech.sk>
	 <21d7e9970904290027v1275c346p8a8f29d2fb4658fb@mail.gmail.com>
Date: Wed, 29 Apr 2009 14:02:40 +0300
Message-ID: <25a99abe0904290402l31e35d3ci509768a683b86096@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] KMS + fb + FBIOPUT_VSCREENINFO
From: Sergey Kvachonok <ravenexp@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Peter Hanzel <hanzelpeter@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem we've had is defining proper semantics for what happens in
> multi-output systems when
> you call this ioctl. Which crtc/output should it set the mode on?
> what happens if the mode isn't valid on all
> connected monitors etc.

Does it really makes all that much sense to run different monitors
with the same mode?
Like embedded notebook panel with weird native resolution and an
external CRT/LCD with
completely unrelated native/preferred modes.

I tried running 2.6.29.1 i915 with one fb per crtc mode,
the first thing it did was to shut down embedded panel and to attach
fbcon to external display.
As fbset doesn't work I couldn't bring the panel back to life, and the
whole thing hung when I con2fb'd one of the VTs to it. Can't provide
more specific data atm, didn't yet try to reproduce   the crash.

BTW fbxine and I believe directfb too use FBIOPUT_VSCREENINFO to
adjust vyres to the maximum to allocate offscreen surfaces for page
flipping.
It isn't really modesetting, but rather framebuffer operation, so is
the color depth setting.
At least these can be painlessly provided with the current setup.

Thanks for listening to my rant,
Sergey
