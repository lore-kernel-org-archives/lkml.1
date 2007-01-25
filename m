Return-Path: <linux-kernel-owner+w=401wt.eu-S933201AbXAYE1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201AbXAYE1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 23:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXAYE1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 23:27:25 -0500
Received: from ns2.suse.de ([195.135.220.15]:48401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933201AbXAYE1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 23:27:24 -0500
Date: Wed, 24 Jan 2007 20:26:16 -0800
From: Greg KH <greg@kroah.com>
To: Christopher Monty Montgomery <xiphmont@gmail.com>
Cc: perex@suse.cz, mclasen@redhat.com, jrb@redhat.com,
       Lennart Poettering <lennart@poettering.net>,
       Pierre Ossman <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org, fedora-desktop-list@redhat.com
Subject: Re: [PATCH] alsa: correct nonsensical sysfs device symlinks
Message-ID: <20070125042616.GA21813@kroah.com>
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 24, 2007 at 08:50:06PM -0500, Christopher Monty Montgomery wrote:
> This patch was generated against 2.6.20-rc5; it fixes a bug that
> cropped up in a late 2.6.19-mm kernel.
> 
> When ALSA's sysfs device creation was converted from using
> class_device_create() to device_create(), the fourth param from
> class_device_create() [dev] was simply plugged into arg 2 of
> device_create().  This causes the device symlinks under all the
> class/sound/[node] to point to nonsensical places.  Among other
> problems, this breaks HAL and all audio software that depends on HAL.

I don't understand, where does the symlink currently point to?  It looks
correct to me on my machines:

$ tree /sys/class/sound/
/sys/class/sound/
|-- card0 -> ../../devices/pci0000:00/0000:00:1b.0/card0
|-- controlC0 -> ../../devices/pci0000:00/0000:00:1b.0/card0/controlC0
|-- pcmC0D0c -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D0c
|-- pcmC0D0p -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D0p
|-- pcmC0D2c -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D2c
|-- pcmC0D6c -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D6c
|-- pcmC0D6p -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D6p
`-- timer -> ../../devices/virtual/sound/timer

What do the symlinks look on your machine?

thanks,

greg k-h
