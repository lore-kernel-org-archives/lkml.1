Return-Path: <linux-kernel-owner+w=401wt.eu-S1759230AbYGFUfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230AbYGFUfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757039AbYGFUfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:35:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38857 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006AbYGFUfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:35:10 -0400
Date: Sun, 6 Jul 2008 21:35:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Frans Pop <elendil@planet.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080706203508.GB28946@ZenIV.linux.org.uk>
References: <20080705131924.GA2083@joi> <20080705235148.GW28946@ZenIV.linux.org.uk> <20080706001148.GX28946@ZenIV.linux.org.uk> <20080706150608.GA5401@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080706150608.GA5401@joi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2008 at 05:07:02PM +0200, Marcin Slusarz wrote:
> On Sun, Jul 06, 2008 at 01:11:48AM +0100, Al Viro wrote:
> > On Sun, Jul 06, 2008 at 12:51:48AM +0100, Al Viro wrote:
> > 
> > > I don't believe that it's right.  Note that if you *do* race there, you
> > > are fucked regardless of sysctls - ppdev.c::register_device() racing
> > > with itself will do tons of fun things all by itself (starting with two
> > > threads allocating different pdev and both setting pp->pdev).
> 
> I wouldn't call it a race - BKL is protecting multiple ioctl calls, so we
> won't ever claim the device from two different threads.

Yes, we can - register_device() does kmalloc() with GFP_KERNEL, which kills
any protection from BKL.  BKL is _not_ providing any kind of exclusion while
you sleep.
