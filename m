Return-Path: <linux-kernel-owner+w=401wt.eu-S933807AbXEPTUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807AbXEPTUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933490AbXEPTTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:19:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1495 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756579AbXEPTTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:19:54 -0400
Date: Wed, 16 May 2007 19:17:18 +0000
From: Pavel Machek <pavel@ucw.cz>
To: J Engel <joern@lazybastard.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516191718.GB4577@ucw.cz>
References: <20070515151919.GA32510@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515151919.GA32510@lazybastard.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

In kernel fsck....

> --- /dev/null	2007-04-18 05:32:26.652341749 +0200
> +++ linux-2.6.21logfs/fs/logfs/progs/fsck.c	2007-05-15 00:54:22.000000000 +0200
> @@ -0,0 +1,332 @@
> +/*
> + * fs/logfs/prog/fsck.c	- filesystem check
> + *
> + * As should be obvious for Linux kernel code, license is GPLv2
> + *
> + * Copyright (c) 2005-2007 Joern Engel
> + *
> + * In principle this could get moved to userspace.  However it might still
> + * make some sense to keep it in the kernel.  It is a pure checker and will
> + * only report problems, not attempt to repair them.
> + */

Is there version that repairs?

> +	/* Some segments are reserved.  Just pretend they were all valid */
> +	reserved = btree_lookup(&super->s_reserved_segments, segno);
> +	if (reserved)
> +		return 0;
> +
> +	err = wbuf_read(sb, dev_ofs(sb, segno, 0), sizeof(sh), &sh);
> +	BUG_ON(err);

BUG is not right thing to do for media error.

> +/*
> + * fs/logfs/prog/mkfs.c	- filesystem generation
> + *
> + * As should be obvious for Linux kernel code, license is GPLv2
> + *
> + * Copyright (c) 2005-2007 Joern Engel
> + *
> + * Should get moved to userspace.
> + */

Indeed. 

> +
> +#if 0
> +/* rootdir */

Please just delete it, not comment it out like this.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
