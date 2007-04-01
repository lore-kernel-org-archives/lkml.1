Return-Path: <linux-kernel-owner+w=401wt.eu-S1751400AbXDABYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbXDABYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 21:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXDABYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 21:24:24 -0400
Received: from smtp.osdl.org ([65.172.181.24]:44030 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbXDABYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 21:24:23 -0400
Date: Sat, 31 Mar 2007 18:24:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Simmons <jsimmons@infradead.org>
Cc: adaplas@gmail.com, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, airlied@linux.ie, geert@linux-m68k.org,
       greg@kroah.com
Subject: Re: [PATCH] fbdev sysfs imrovements
Message-Id: <20070331182400.317728d7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704010156001.5314@pentafluge.infradead.org>
References: <Pine.LNX.4.64.0703192055090.27580@pentafluge.infradead.org>
	<20070326195807.184474d7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704010156001.5314@pentafluge.infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 1 Apr 2007 01:56:28 +0100 (BST) James Simmons <jsimmons@infradead.org> wrote:
> 
> I can't seem to duplicate this error.

OK, I'll poke at it some more.

>  Do you have any patches applied to 
> the nvidia driver?

I don't think so - whatever's in -mm.

> On Mon, 26 Mar 2007, Andrew Morton wrote:
> 
> > On Tue, 20 Mar 2007 14:25:49 +0000 (GMT) James Simmons <jsimmons@infradead.org> wrote:
> > 
> > > This patch does several things to allow the underlying hardware to be 
> > > shared amount many devices. The most important thing is the use of
> > > the created device via device_create instead of the hardware device. No 
> > > longer should fbdev drivers use the xxx_set_drvdata with the parent
> > > bus device. The second change is having a bus independent power management
> > > for the framebuffer driver. The final change is using the release method 
> > > to cleanup the device. The reason again is to make the fbdev driver 
> > > independent of the bus parent device. Feedback is welcomed.
> > 
> > Causes an early crash on the powermac G5.
> > 
> > http://userweb.kernel.org/~akpm/s5000489.jpg (the oops is the usual powerpc
> > mess)
> > 
> > config at http://userweb.kernel.org/~akpm/config-g5.txt
> > 
