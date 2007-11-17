Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXKQJPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXKQJPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 04:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXKQJOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 04:14:54 -0500
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:52501 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbXKQJOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 04:14:52 -0500
Date: Sat, 17 Nov 2007 11:16:30 +0100
From: Andreas Herrmann <aherrman@arcor.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix UTS_MACHINE to be "i386" for 32-bit build and "x86_64" for 64-bit build
Message-ID: <20071117101630.GA5102@devil>
References: <20071116111446.GA16968@devil> <20071116123747.GA12086@devil> <473DB52F.2040703@zytor.com> <20071116221535.GA1810@uranus.ravnborg.org> <473E209A.7080806@zytor.com> <20071117075715.GB4723@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117075715.GB4723@uranus.ravnborg.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 08:57:15AM +0100, Sam Ravnborg wrote:
> > >
> > >Any good suggestions here???
> > >UTS_MACHINE is set in top-level Makefile and if we specify
> > >make ARCH=x86
> > >we do not know if i386 or x86_&4 is correct until the configuration
> > >has been read.
> > >
> > >Should we report a "make ARCH=x86" as uname -m == x86??
> > >
> > 
> > That would break 5 years of a stable ABI.  I don't think that is even 
> > remotely feasible.
> 
> I will try to cook up a patch that sets CONFIG_UTS_MACHINE
> and then we will use that value unless it is undefined in which
> case we fall back to UTS_MACHINE (as today).


IMHO we shouldn't add another config option.
Just correctly set UTS_MACHINE in arch/x86/Makefile will do it.

I wasn't aware where the machine name came from.
Now that I know that (and shamelessly copying ideas from s390;-)
it is easy to fix. See attached patch.

Testing a crosscompiled 32-bit-kernel I now get
    # uname -m
    i686
on my K7.

Other tests will follow. But patch looks sane and should go mainline asap, I think.


Regards,

Andreas

--
x86: fix UTS_MACHINE to be "i386" for 32-bit build and "x86_64" for 64-bit build.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 arch/x86/Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 116b03a..7aa1dc6 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -11,10 +11,9 @@ endif
 $(srctree)/arch/x86/Makefile%: ;
 
 ifeq ($(CONFIG_X86_32),y)
+        UTS_MACHINE := i386
         include $(srctree)/arch/x86/Makefile_32
 else
+        UTS_MACHINE := x86_64
         include $(srctree)/arch/x86/Makefile_64
 endif
-
-
-
-- 
1.5.3.4


