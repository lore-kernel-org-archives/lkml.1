Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbYGDJO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbYGDJO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 05:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbYGDJOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 05:14:19 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:60138 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754485AbYGDJOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 05:14:18 -0400
Date: Fri, 4 Jul 2008 11:12:24 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       tony@atomide.com, paul@pwsan.com, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, ian <spyro@f2s.com>
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing
 clocks.
Message-ID: <20080704111224.54961b66@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080704090446.GA6848@doriath.ww600.siemens.net>
References: <20080626125033.GA7093@doriath.ww600.siemens.net>
	<20080626125138.GA12415@doriath.ww600.siemens.net>
	<20080703203157.GB24620@fluff.org.uk>
	<20080704090446.GA6848@doriath.ww600.siemens.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Jul 2008 09:12:32.0989 (UTC) FILETIME=[179B28D0:01C8DDB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> > > +#ifdef CONFIG_DEBUG_FS
> > > +	struct dentry *dir;
> > > +	struct dentry *info;
> > > +#endif  
> > 
> > Can't you hide this in the code, say by wrappering the
> > struct with something else when it is registered?  
> 
> It is allocated dynamically by drivers. I can move this to
> struct clk_private to specify that it's private, but it should be
> visible outside

Actually, I don't think it _should_ be private. Low-level clock drivers
might want to provide debugfs nodes on their own, and those nodes
naturally belong in the same directory as the clklib ones. So the
debugfs root node must be exposed somehow.

You can get rid of the "info" field if you apply this patch:

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/driver-core/debugfs-implement-debugfs_remove_recursive.patch

Haavard
