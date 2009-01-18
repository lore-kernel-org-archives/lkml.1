Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZARVCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZARVCn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 16:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZARVCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 16:02:33 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:52779 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbZARVCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 16:02:32 -0500
Date: Sun, 18 Jan 2009 22:04:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
Message-ID: <20090118210416.GE2978@uranus.ravnborg.org>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <20080226112840.GA29465@uranus.ravnborg.org> <alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr> <20081226194833.GA8306@uranus.ravnborg.org> <alpine.LSU.2.00.0812262049040.12031@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0812262049040.12031@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 08:50:34PM +0100, Jan Engelhardt wrote:
> 
> On Friday 2008-12-26 20:48, Sam Ravnborg wrote:
> >> >> 
> >> >> This patch allows kernel modules to be compressed when 'make
> >> >> modules_install' is run after being copied to
> >> >> the /lib/module/<version>/<...> directory which is useful if you have
> >> >> module-init-tools installed with --enable-zlib. This patch adds an
> >> >> option (MODULE_COMPRESS) to the kernel configuration file (specifically
> >> >> init/Kconfig) so that the kernel modules will compressed if
> >> >> MODULE_COMPRESS is set.
> >> 
> >> I recently started compressing my kernel modules and that saved me
> >> at least 70 MB of disk space on mostlyallmodconfig.
> >> (And no, the argument of disks being cheap is not so true with
> >> CF or SSD.)
> >> Distro is lazy and wants to wait for upstream to have it,
> >> so is there any chance of getting this proposal in?
> >
> >Steve said he wanted to try to make the solution more
> >scalable so I am awaiting a new patch.
> 
> Hm, all I needed was this patch. It might fire up some people,
> but it's got all the scalability I could think of..

Can I ask you to redo this patch.
I want a way to swith off compression, but it should default be enable.
So if KBUILD_MODULE_NOCOMPRESS is undefined we will compress the modules
when we install them.

Something like:

      cmd_modules_install =                                               \
         mkdir -p $(2); cp $@ $(2) ;                                      \
         $(mod_strip_cmd) $(2)/$(notdir $@)                               \
         $(if $(KBUILD_MODULES_NOCOMPRESS),, ;gzip -9f $(2)/$(notdir $@))

And add documentation to Documentation/kbuild/kbuild.txt too...

Thanks,
	Sam
