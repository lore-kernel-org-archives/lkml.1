Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYKEVjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYKEVjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753524AbYKEVjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:39:46 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55283 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbYKEVjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:39:45 -0500
Date: Wed, 5 Nov 2008 22:41:17 +0100
From: Pavel Machek <pavel@suse.cz>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V4 3/6] Configfs support for IR
Message-ID: <20081105214117.GB3966@elf.ucw.cz>
References: <20081105194640.19407.19682.stgit@localhost> <20081105194742.19407.35855.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105194742.19407.35855.stgit@localhost>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-11-05 14:47:42, Jon Smirl wrote:
> Now uses configfs to build mappings from remote buttons to key strokes. When ir-core loads it creates /config/remotes. Make a directory for each remote you have; this will cause a new input devices to be created. Inside these directories make a directory for each key on the remote. In the key directory attributes fill in the protocol, device, command, keycode. Since this is configfs all of this can be easily scripted.
> 
> Now when a key is pressed on a remote, the configfs directories are searched for a match on protocol, device, command. If a matches is found, a key stroke corresponding to keycode is created and sent on the input device that was created when the directory for the remote was made.
> 
> The configfs directories are pretty flexible. You can use them to map multiple remotes to the same key stroke, or send a single button push to multiple apps.
> ---
>  drivers/input/ir/Makefile      |    2 
>  drivers/input/ir/ir-configfs.c |  333 ++++++++++++++++++++++++++++++++++++++++
>  drivers/input/ir/ir-core.c     |   15 +-
>  3 files changed, 339 insertions(+), 11 deletions(-)
>  create mode 100644 drivers/input/ir/ir-configfs.c
> 
> diff --git a/drivers/input/ir/Makefile b/drivers/input/ir/Makefile
> index 6acb665..2ccdda3 100644
> --- a/drivers/input/ir/Makefile
> +++ b/drivers/input/ir/Makefile
> @@ -4,5 +4,5 @@
>  # Each configuration option enables a list of files.
>  
>  obj-$(CONFIG_INPUT_IR)		+= ir.o
> -ir-objs := ir-core.o
> +ir-objs := ir-core.o ir-configfs.o
>  
> diff --git a/drivers/input/ir/ir-configfs.c b/drivers/input/ir/ir-configfs.c
> new file mode 100644
> index 0000000..0fec855
> --- /dev/null
> +++ b/drivers/input/ir/ir-configfs.c
> @@ -0,0 +1,333 @@
> +/*
> + * Configfs routines for IR support
> + *
> + *   configfs root
> + *   --remotes
> + *   ----specific remote
> + *   ------keymap
> + *   --------protocol
> + *   --------device
> + *   --------command
> + *   --------keycode
> + *   ------repeat keymaps
> + *   --------....
> + *   ----another remote
> + *   ------more keymaps
> + *   --------....
> + *
> + * Copyright (C) 2008 Jon Smirl <jonsmirl@gmail.com>

GPL?

Maybe those -s should be /s?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
