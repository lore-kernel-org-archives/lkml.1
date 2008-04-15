Return-Path: <linux-kernel-owner+w=401wt.eu-S1762916AbYDOBWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762916AbYDOBWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbYDOBV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:21:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754931AbYDOBV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:21:56 -0400
Date: Mon, 14 Apr 2008 18:21:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, info-linux@geode.amd.com,
       jordan.crouse@amd.com, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/3] OLPC: gxfb/lxfb: add DCON panel modes to
 framebuffer drivers
Message-Id: <20080414182112.848bcb64.akpm@linux-foundation.org>
In-Reply-To: <20080414035302.794dcd7a@ephemeral>
References: <20080414035302.794dcd7a@ephemeral>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 03:53:02 -0400 Andres Salomon <dilinger@queued.net> wrote:

> 
> Since there's no way to autodetect panel modes, we're forced to hardcode
> them in the driver and add a big fat #ifdef.  The OLPC DCON needs a
> specific mode line (at 1200x900).  This adds it to both gxfb and lxfb.
> 
> ...
>
> +static const struct fb_videomode gx_dcon_modedb[] __initdata = {
> +const struct fb_videomode olpc_dcon_modedb[] __initdata = {

include/linux/init.h:38 points out that `const' and `__initdata' should
not be mixed.

I forget which architecture/compiler versions explode when we do this.  But
it's not x86, iirc.

Still, it's poor form and, err, I don't immediately recall which tag we
_should_ use, and the comments in there are unhelpful.  It might be
__initconst, but that has exactly zero users.  Help.

