Return-Path: <linux-kernel-owner+w=401wt.eu-S1757261AbZAWFV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbZAWFV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 00:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZAWFVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 00:21:51 -0500
Received: from vena.lwn.net ([206.168.112.25]:60256 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbZAWFVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 00:21:50 -0500
Date: Thu, 22 Jan 2009 22:21:41 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, viro@ZenIV.linux.org.uk, oleg@redhat.com,
       linux-api@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-ID: <20090122222141.4a9501e1@tpl>
In-Reply-To: <20090122160935.GI15750@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122160935.GI15750@one.firstfloor.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2009 17:09:35 +0100
Andi Kleen <andi@firstfloor.org> wrote:

> > OK, replacing a lock_kernel() with a spin_lock(&global_lock) is
> > pretty straightforwad.  But it's really really sad.  It basically
> > leaves a great big FIXME in there.  It'd be better to fix it.  
> 
> Also it might be that it's even worse than the BKL.

I don't quite see how now.  Like the BKL, it's a spinlock.

> It would still require a bitlock because some state in the low
> level fasync needs to be protected.
> 
> Oleg has a proposal to do this using a flag bit which seemed
> reasonable to me.

I didn't see a reason to add a one-off custom locking regime for such a
non-hot-path situation.  But it would certainly work; if we want to go
that way I'll not fight it.

jon
