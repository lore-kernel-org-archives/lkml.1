Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbZARVHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbZARVHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 16:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbZARVG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 16:06:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:58389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbZARVG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 16:06:58 -0500
Date: Sun, 18 Jan 2009 13:09:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-ID: <20090118130908.390eb07b@infradead.org>
In-Reply-To: <20090118210416.GE2978@uranus.ravnborg.org>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk>
	<20080226112840.GA29465@uranus.ravnborg.org>
	<alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr>
	<20081226194833.GA8306@uranus.ravnborg.org>
	<alpine.LSU.2.00.0812262049040.12031@fbirervta.pbzchgretzou.qr>
	<20090118210416.GE2978@uranus.ravnborg.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jan 2009 22:04:16 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Fri, Dec 26, 2008 at 08:50:34PM +0100, Jan Engelhardt wrote:
> > 
> > On Friday 2008-12-26 20:48, Sam Ravnborg wrote:
> > >> >> 
> > >> >> This patch allows kernel modules to be compressed when 'make
> > >> >> modules_install' is run after being copied to
> > >> >> the /lib/module/<version>/<...> directory which is useful if
> > >> >> you have module-init-tools installed with --enable-zlib. This
> > >> >> patch adds an option (MODULE_COMPRESS) to the kernel
> > >> >> configuration file (specifically init/Kconfig) so that the
> > >> >> kernel modules will compressed if MODULE_COMPRESS is set.
> > >> 
> > >> I recently started compressing my kernel modules and that saved
> > >> me at least 70 MB of disk space on mostlyallmodconfig.
> > >> (And no, the argument of disks being cheap is not so true with
> > >> CF or SSD.)
> > >> Distro is lazy and wants to wait for upstream to have it,
> > >> so is there any chance of getting this proposal in?
> > >
> > >Steve said he wanted to try to make the solution more
> > >scalable so I am awaiting a new patch.
> > 
> > Hm, all I needed was this patch. It might fire up some people,
> > but it's got all the scalability I could think of..
>  
> Can I ask you to redo this patch.
> I want a way to swith off compression, but it should default be
> enable. So if KBUILD_MODULE_NOCOMPRESS is undefined we will compress
> the modules when we install them.
> 

especially since the decompression is an option for the module tools,
it should be an option for the kernel... 
since it does add a dependency for the module tools (and one that you
might not need; for example I disabled it just to remove a build
requires)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
