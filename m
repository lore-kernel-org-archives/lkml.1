Return-Path: <linux-kernel-owner+w=401wt.eu-S1758475AbYGFQBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758475AbYGFQBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 12:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbYGFQBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 12:01:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:36148 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757AbYGFQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 12:01:39 -0400
Date: Sun, 6 Jul 2008 09:01:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] parport/ppdev: fix registration of sysctl entries
Message-ID: <20080706090138.5a71e04f@infradead.org>
In-Reply-To: <20080706150608.GA5401@joi>
References: <20080705131924.GA2083@joi>
	<20080705235148.GW28946@ZenIV.linux.org.uk>
	<20080706001148.GX28946@ZenIV.linux.org.uk>
	<20080706150608.GA5401@joi>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008 17:07:02 +0200
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> On Sun, Jul 06, 2008 at 01:11:48AM +0100, Al Viro wrote:
> > On Sun, Jul 06, 2008 at 12:51:48AM +0100, Al Viro wrote:
> > 
> > > I don't believe that it's right.  Note that if you *do* race
> > > there, you are fucked regardless of sysctls -
> > > ppdev.c::register_device() racing with itself will do tons of fun
> > > things all by itself (starting with two threads allocating
> > > different pdev and both setting pp->pdev).
> 
> I wouldn't call it a race - BKL is protecting multiple ioctl calls,
> so we won't ever claim the device from two different threads.

eh... there's sleeping functions in there.. the BKL doesn't protect you
squat ;)(


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
