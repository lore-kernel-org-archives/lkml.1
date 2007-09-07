Return-Path: <linux-kernel-owner+w=401wt.eu-S965653AbXIGRuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965653AbXIGRuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 13:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757997AbXIGRu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 13:50:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:22334 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757960AbXIGRu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 13:50:28 -0400
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
From: Daniel Walker <dwalker@mvista.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
In-Reply-To: <200709071830.17027.vda.linux@googlemail.com>
References: <200709051443.21522.vda.linux@googlemail.com>
	 <200709061807.33740.vda.linux@googlemail.com>
	 <1189182671.6303.42.camel@imap.mvista.com>
	 <200709071830.17027.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Fri, 07 Sep 2007 10:38:09 -0700
Message-Id: <1189186690.7636.12.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-07 at 18:30 +0100, Denys Vlasenko wrote:
> On Friday 07 September 2007 17:31, Daniel Walker wrote:
> > On Thu, 2007-09-06 at 18:07 +0100, Denys Vlasenko wrote:
> > > A bit extended version:
> > > 
> > > In the process in making it work I saw ~10% vmlinux size reductions
> > > (which basically matches what Marcelo says) when I wasn't retaining
> > > sections needed for EXPORT_SYMBOLs, but module loading didn't work.
> > > 
> > > Thus I fixed that by adding KEEP() directives so that EXPORT_SYMBOLs
> > > are never discarded. This was just one of many fixes until kernel
> > > started to actually boot and work.
> > > 
> > > I did that before I posted patches to lkml.
> > > IOW: posted patches are not broken versus module loading.
> > 
> > Ok, this is more like the explanation I was looking for..
> > 
> > During this thread you seemed to indicate the patches you release
> > reduced the kernel ~10% , but now your saying that was pre-release ,
> > right?
> 
> CONFIG_MODULE=n will save ~10%
> CONFIG_MODULE=y - ~1%
> 
> Exact figure depends on .config (whether you happen to include
> especially "fat" code or not).
> 
> I want to explain a bit where I am coming from. I am working on busybox,
> and last release made busybox smaller by "whopping" 2%. This is the result
> of a hundred or so of small code and data shrinks.
> 
> It basically means that I am close to the point of diminishing returns
> trying to make busybox smaller, and memory wastage on the running
> embedded system is now elsewhere - including kernel.

I think this type of pruning is a good thing, you could even say the
biggest bit of low hanging fruit in terms of size reduction. 

I think your patches are good, but need some work. There are still some
changes that could reduce the kernel further (i.e. when modules are
used) .. So I'm not trying to discourage you, but you set off some
alarms with me early in the thread.. Which caused this to drag out..

Daniel

