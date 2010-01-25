Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230Ab0AYQ7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0AYQ7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 11:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171Ab0AYQ7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 11:59:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:59920 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159Ab0AYQ7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 11:59:02 -0500
Date: Mon, 25 Jan 2010 17:59:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
Cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com, pavel@ucw.cz, jayakumar.lkml@gmail.com,
       linux-fbdev@vger.kernel.org, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.4
In-Reply-To: <acd6dfcf4391c081f861d430c0b45311.squirrel@intranet.cs.nmsu.edu>
Message-ID: <alpine.LNX.2.00.1001251758230.30977@pobox.suse.cz>
References: <201001202047.o0KKlMTr014003@mustang.cs.nmsu.edu>    <201001202219.12058.oliver@neukum.org> <acd6dfcf4391c081f861d430c0b45311.squirrel@intranet.cs.nmsu.edu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010, Rick L. Vinyard, Jr. wrote:

> > Am Mittwoch, 20. Januar 2010 21:47:22 schrieb Rick L. Vinyard Jr.:
> >> +       if (copy_from_user(dst, buf, count))
> >> +               err = -EFAULT;
> >> +
> >> +       if (!err)
> >> +               *ppos += count;
> >> +
> >> +       g13_fb_update(par);
> >> +
> >> +       return (err) ? err : count;
> >
> > Do you really want to go on if you get -EFAULT?
> >
> 
> Since the hecubafb driver (which I based this portion of the g13 driver
> on) uses the same approach I tried to justify it myself when I first saw
> it.
> 
> I don't know if this was the intent of the hecubafb author, but this is
> the way I saw it.
> 
> By this point the copy_from_user() has failed. If it resulted in a partial
> copy to dst then continuing on to an update can't hurt, and would reduce
> display jitter if a re-write occurs from userspace. If a re-write doesn't
> occur the virtual framebuffer is hosed anyways as dst is is the underlying
> framebuffer.
> 
> Given that, the worst-case consequence seems to be an unnecessary update
> to the device display.

Well, it's quite questionable (and I'd say unexpected) behavior to go on 
even if userspace passes wild pointers to kernel.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
