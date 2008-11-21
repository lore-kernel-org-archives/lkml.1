Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYKUGsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYKUGsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 01:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYKUGsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 01:48:45 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:54526 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYKUGso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 01:48:44 -0500
From: Mikael Starvik <mikael.starvik@axis.com>
To: Sam Ravnborg <sam@ravnborg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 21 Nov 2008 07:48:35 +0100
Subject: RE: headers-y for machines
Thread-Topic: headers-y for machines
Thread-Index: AclLT8+ZYEL0oOZ8RH2FVwZj2z0PLwAVRcQw
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D053B05D4090A@xmail3.se.axis.com>
References: <4BEA3FF3CAA35E408EA55C7BE2E61D053B05D40823@xmail3.se.axis.com>
 <20081120190819.GA15838@uranus.ravnborg.org>
 <20081120203637.GA21308@uranus.ravnborg.org>
In-Reply-To: <20081120203637.GA21308@uranus.ravnborg.org>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks a lot Sam!

I agree that this is a rare case. We find it useful to keep kernel code simple and sometimes lift out some machine specific calculations or algorithms to userspace. I will enter your diff in our local CVS. It's up to you if you would like to add it in mainline or not.

Best Regards
/Mikael

-----Original Message-----
From: Sam Ravnborg [mailto:sam@ravnborg.org] 
Sent: den 20 november 2008 21:37
To: Mikael Starvik
Cc: linux-kernel@vger.kernel.org
Subject: Re: headers-y for machines

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
