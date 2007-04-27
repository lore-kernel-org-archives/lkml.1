Return-Path: <linux-kernel-owner+w=401wt.eu-S1756070AbXD0QmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbXD0QmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756072AbXD0QmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:42:23 -0400
Received: from canuck.infradead.org ([209.217.80.40]:39281 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbXD0QmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:42:22 -0400
Date: Fri, 27 Apr 2007 09:39:51 -0700
From: Greg KH <greg@kroah.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Hellstr?m <thomas@tungstengraphics.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
Message-ID: <20070427163951.GA12216@kroah.com>
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 04:55:14PM +1000, Dave Airlie wrote:
>  Hi,
> 
>  The patch is too big to fit on the list and I've no idea how we could
>  break it down further, it just happens to be a lot of new code..
> 
>  http://people.freedesktop.org/~airlied/ttm/0001-drm-Implement-TTM-Memory-manager-core-functionality.txt
> 
>  The patch header and diffstat are below,

A few easy and simple comments based on looking at this for 5 minutes:
  - drop the typedefs.  Yeah, they might be a drm thing, but we don't
    need them here.
  - the comment style for the functions is "odd" and not in kerneldoc
    form, but something else.  Either use kerneldoc or nothing, don't
    invent something new please.
  - what's with the /proc interface?  Don't add new proc code for
    non-process related things.  This should all go into sysfs
    somewhere.  And yes, I know /proc/dri/ is there today, but don't add
    new stuff please.
  - struct drm_bo_arg can't use an int or unsigned, as it crosses the
    userspace/kernelspace boundry, use the proper types for all values
    in those types of structures (__u32, etc.)
  - there doesn't seem to be any validity checking for the arguments
    passed into this new ioctl.  Possibly that's just the way the rest
    of the dri interface is, which is scary, but with the memory stuff,
    you really should check things properly...

that's enough to start with :)

thanks,

greg k-h
