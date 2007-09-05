Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbXIETgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbXIETgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:36:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932114AbXIETgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:36:47 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:44253 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbXIETgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:36:46 -0400
Subject: Re: [PATCH 0/3] build system: section garbage collection for
	vmlinux
From: Daniel Walker <dwalker@mvista.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070905193150.GI16016@stusta.de>
References: <200709051443.21522.vda.linux@googlemail.com>
	 <200709051937.04014.vda.linux@googlemail.com>
	 <1189017519.4442.24.camel@imap.mvista.com>
	 <200709052014.12653.vda.linux@googlemail.com>
	 <20070905193150.GI16016@stusta.de>
Content-Type: text/plain
Date: Wed, 05 Sep 2007 12:24:04 -0700
Message-Id: <1189020244.4442.32.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 21:31 +0200, Adrian Bunk wrote:
> On Wed, Sep 05, 2007 at 08:14:12PM +0100, Denys Vlasenko wrote:
> > On Wednesday 05 September 2007 19:38, Daniel Walker wrote:
> > > > > You version doesn't work with CONFIG_MODULES right?
> > > > 
> > > > It works with CONFIG_MODULES.
> > > 
> > > Really? Take a look at this version,
> > > 
> > > http://lkml.org/lkml/2006/6/4/169
> > > 
> > > Marcello had to implement a two pass build to add back symbol used in
> > > modules which got removed from the main kernel.. You don't appear to do
> > > that. Marcelo also claims better size reduction than you.
> > 
> > This will discard EXPORT_SYMBOLs potentially used by
> > out-of-tree modules.
> > 
> > I also saw ~10% size reductions, but then at run-time test modules
> > failed to load, they didn't find needed symbols.
> > 
> > OTOH if I know that I am not going to be using such modules,
> > then this can be done. Will require another CONFIG_xxx, though.
> 
> One point to keep in mind is that the space penalty of CONFIG_MODULES=y 
> is so big that CONFIG_MODULES=n is actually the most interesting case 
> for small systems that really need small kernels.

Marcelo's version actual deals with the CONFIG_MODULES=y penalty , which
is interesting to me .. It removes symbols added for CONFIG_MODULES
which actually aren't used .. So CONFIG_MODULES=y is just as interesting
as without (to me at least..).

Daniel

