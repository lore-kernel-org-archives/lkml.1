Return-Path: <linux-kernel-owner+w=401wt.eu-S1753129AbYIVPlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbYIVPlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbYIVPlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:41:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbYIVPlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:41:39 -0400
Date: Mon, 22 Sep 2008 11:41:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Giacomo A. Catenazzi" <cate@cateee.net>
cc: Takashi Iwai <tiwai@suse.de>, Chris Li <lkml@chrisli.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
In-Reply-To: <48D79FFD.1060102@cateee.net>
Message-ID: <alpine.DEB.1.10.0809221138250.14496@gandalf.stny.rr.com>
References: <s5hbpyny7bl.wl%tiwai@suse.de> <20080918122541.2c3c7b39@areia.chehab.org> <48D27734.3040600@cateee.net> <alpine.LFD.1.10.0809181154020.12224@bombadil.infradead.org> <48D36D02.4090003@cateee.net> <s5hy71oyviu.wl%tiwai@suse.de>
 <70318cbf0809191655m89e4b4fo68c3693487afed98@mail.gmail.com> <s5hk5d4xzw0.wl%tiwai@suse.de> <48D79FFD.1060102@cateee.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Sep 2008, Giacomo A. Catenazzi wrote:
> Takashi Iwai wrote:
> > At Fri, 19 Sep 2008 16:55:51 -0700,
> > Chris Li wrote:
> > 
> > > I avoid arch/ and firmware/ because it is nasty. I figure module in
> > > arch/ is small enough I don't mind building it. And the firmware
> > > directory,
> > > if I don't build the module loads it. Those firmware will automatically
> > > skipped
> > > any way.
> > 
> > Agreed.
> > 
> > > The little tricky part is some thing like this:
> > > ========================
> > > ifeq ($(CONFIG_BLK_DEV_CMD640), m)
> > >         obj-m += cmd640.o
> > > endif
> > > ========================
> > > Internally it get convert it into:
> > > "obj-$(CONFIG_BLK_DEV_CMD640) += cmd640.o"
> 
> Are you sure?
> I.e. if you set CONFIG_BLK_DEV_CMD640=y, you see that
> the two constructs gives different results.
> 
> If the makefile author did such complex construct, I
> really think there is a reason ;-)
> 

Yes indeed, we should find out what the author meant.

 ifeq ($(CONFIG_BLK_DEV_CMD640), m)
	obj-m += cmd640.o
 endif

and

 obj-$(CONFIG_BLK_DEV_CMD640) += cmd640.o

mean two different things.

The former means to compile the cmd640 only if it is set to a module.
The later means to compile the cmd640 if it is either a module or built 
into the core kernel code.

The author needs to make this change or explain why it is like this.

-- Steve

