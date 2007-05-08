Return-Path: <linux-kernel-owner+w=401wt.eu-S967917AbXEHULA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967917AbXEHULA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967846AbXEHUKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:10:55 -0400
Received: from waste.org ([66.93.16.53]:33833 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967084AbXEHUKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:10:54 -0400
Date: Tue, 8 May 2007 15:10:47 -0500
From: Matt Mackall <mpm@selenic.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] Create a top-level "Space-critical features" menu.
Message-ID: <20070508201046.GU11166@waste.org>
References: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705080356020.10881@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:06:30AM -0400, Robert P. J. Day wrote:
> 
>   i've always hated that lower-level menu under "General setup":
> 
> Configure standard kernel features (for small systems)  --->
> 
> which buries the choice of de-selecting features to save space one
> level down without really explaining what it's all about.  so i just
> shifted all of that up to the top under what i think is a more
> meaningful name.

WTF. It certainly does explain what it's all about (hint: hit '?') and
you've clearly failed to read it, even while creating the patch.

>   this patch is also why i asked earlier why top-level menu entries
> have no "help" text -- because, in this case, it would be useful for
> someone looking at the config screen to see that choice and be able to
> ask, "hey, i wonder what *that's* all about", and get help along the
> lines of:
> 
>   "these features are normally selected but, if you're strapped for
> space, such as with embedded systems, you might consider turning some
> of them off.  if space isn't an issue, you might as well just leave
> them as they are."  (or something like that.)

NAK. Let's actually read that config option description:

menuconfig EMBEDDED
        bool "Configure standard kernel features (for small systems)"
        help
          This option allows certain base kernel options and settings
          to be disabled or tweaked. This is for specialized
          environments which can tolerate a "non-standard" kernel.
          Only use this if you really know what you are doing.

That means this option is for specialized environments which can
tolerate a non-standard kernel and people should only use it if they
really know what they're doing.

Think about what non-standard means. We absolutely don't want to hear
from anyone whose machine silently crashed only to discover they
accidentally had CONFIG_PRINTK off. None of the options in that menu
are of any interest to the average user and they shouldn't be using
them.

Feel free to suggest better help text if that isn't clear enough.

-- 
Mathematics is the supreme nostalgia of our time.
