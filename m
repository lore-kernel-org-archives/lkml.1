Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbYKTUhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbYKTUhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbYKTUhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:37:10 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:55383 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbYKTUhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:37:09 -0500
Date: Thu, 20 Nov 2008 21:36:37 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mikael Starvik <mikael.starvik@axis.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: headers-y for machines
Message-ID: <20081120203637.GA21308@uranus.ravnborg.org>
References: <4BEA3FF3CAA35E408EA55C7BE2E61D053B05D40823@xmail3.se.axis.com> <20081120190819.GA15838@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120190819.GA15838@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 08:08:19PM +0100, Sam Ravnborg wrote:
> Hi Mikael.
> 
> On Thu, Nov 20, 2008 at 09:48:45AM +0100, Mikael Starvik wrote:
> > Lets say you have arch/arm/mach-xx/include/mach/myfile.h and want to add myfile.h to header-y. How do you do that?
> > 
> > I tried to add 
> > 
> > header-y += ../../maxh-xx/
> > 
> > in arch/arm/include/asm/Kbuild
> > 
> > and then
> > header-y += myfile.h in arch/arm/mach-xx/include/mach/Kbuild
> 
> When we did the header file rearrange I had not foreseen that we would export header files
> located anywhere else than include/* and arch/$ARCH/include so there is
> no way to properly export files located in arch/$ARCH/mach-foo/...
> 
> Do we really want to export files form this location to userspace?

One way to support this could be to add the possibility to specify where
to install the header files.
Like this patch:

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 612dc13..1760113 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -14,6 +14,8 @@ _dst := $(if $(dst),$(dst),$(obj))
 kbuild-file := $(srctree)/$(obj)/Kbuild
 include $(kbuild-file)

+_dst := $(if $(header-dest-y),$(header-dest-y),$(_dst))
+
 include scripts/Kbuild.include

 install       := $(INSTALL_HDR_PATH)/$(_dst)


With this you could add:
header-dest-y := include/mach-foo

to the Kbuild file despite having it located somewhere else in the tree.

	Sam
