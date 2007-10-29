Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbXJ2XYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbXJ2XYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 19:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbXJ2XYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 19:24:13 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:13622 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbXJ2XYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 19:24:12 -0400
Date: Mon, 29 Oct 2007 11:19:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &
 CONFIG_VIDEO_SAA7146_VV=y
Message-Id: <20071029111906.c488393f.randy.dunlap@oracle.com>
In-Reply-To: <20071029123533.GA17331@linuxtv.org>
References: <20071026073736.GA24172@elte.hu>
	<20071027213057.GA15211@linuxtv.org>
	<20071027163932.e0a0522b.randy.dunlap@oracle.com>
	<20071029112303.GA18994@elte.hu>
	<20071029123533.GA17331@linuxtv.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 13:35:33 +0100 Johannes Stezenbach wrote:

> On Mon, Oct 29, 2007, Ingo Molnar wrote:
> > * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> > > > config VIDEO_SAA7146_VV
> > > > 	tristate
> > > > 	depends on VIDEO_DEV = y || VIDEO_DEV = VIDEO_SAA7146_VV
> > > > 	select VIDEOBUF_DMA_SG
> > > > 	select VIDEO_SAA7146
> > > > 
> > > > (untested)
> > > 
> > > Nope, won't work.  I tried that last night.  VIDEO_DEV_SAA7146_VV
> > > has too many "select"s involved, but select doesn't follow the dependency
> > > chains.  IOW, as written in Documentation/kbuild/kconfig-language.txt:
> > > 
> > > 	select is evil.... select will by brute force set a symbol
> > > 	equal to 'y' without visiting the dependencies. So abusing
> > > 	select you are able to select a symbol FOO even if FOO depends
> > > 	on BAR that is not set.
> > 
> > so ... what should we do? Remove those ~7 select VIDEO_SAA7146_VV lines 
> > and replace them with depends on VIDEO_SAA7146_VV ?
> 
> Hm, the idea is that the SAA7146 driver is like a library,
> and the V4L or DVB card drivers select the library functions
> they need (base driver or common V4L helper functions).
> The user shouldn't have to worry about those details.
> 
> But yeah, if it's not possible to do that with kbuild then
> it's probably best to s/select/depends on/ for VIDEO_SAA7146_VV
> and provide a meaningful help text for VIDEO_SAA7146_VV.

I don't have a better suggestion, but VIDEO_SAA7146_VV will need
a prompt and help text if a user can enable/disable it.

---
~Randy
