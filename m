Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbXJ0Xlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbXJ0Xlj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 19:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXJ0Xlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 19:41:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23626 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbXJ0Xlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 19:41:31 -0400
Date: Sat, 27 Oct 2007 16:39:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &
 CONFIG_VIDEO_SAA7146_VV=y
Message-Id: <20071027163932.e0a0522b.randy.dunlap@oracle.com>
In-Reply-To: <20071027213057.GA15211@linuxtv.org>
References: <20071026073736.GA24172@elte.hu>
	<20071027213057.GA15211@linuxtv.org>
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

On Sat, 27 Oct 2007 23:30:57 +0200 Johannes Stezenbach wrote:

> On Fri, Oct 26, 2007, Ingo Molnar wrote:
> > 
> > the attached config (generated via make randconfig) fails to build due 
> > to the combination of these config entries:
> > 
> >   CONFIG_VIDEO_DEV=m
> >   CONFIG_VIDEO_SAA7146_VV=y
> > 
> > i found no obvious Kconfig way to force VIDEO_SAA7146_VV to be modular 
> > when VIDEO_DEV is modular - is there a good solution for this?
> 
> According to http://lkml.org/lkml/2007/10/21/226 :
> 
> config VIDEO_SAA7146_VV
> 	tristate
> 	depends on VIDEO_DEV = y || VIDEO_DEV = VIDEO_SAA7146_VV
> 	select VIDEOBUF_DMA_SG
> 	select VIDEO_SAA7146
> 
> (untested)

Nope, won't work.  I tried that last night.  VIDEO_DEV_SAA7146_VV
has too many "select"s involved, but select doesn't follow the dependency
chains.  IOW, as written in Documentation/kbuild/kconfig-language.txt:

	select is evil.... select will by brute force set a symbol
	equal to 'y' without visiting the dependencies. So abusing
	select you are able to select a symbol FOO even if FOO depends
	on BAR that is not set.


---
~Randy
