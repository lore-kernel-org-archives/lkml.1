Return-Path: <linux-kernel-owner+w=401wt.eu-S965672AbXBGHnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965672AbXBGHnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 02:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161009AbXBGHnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 02:43:11 -0500
Received: from koto.vergenet.net ([210.128.90.7]:57005 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965672AbXBGHnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 02:43:10 -0500
Date: Wed, 7 Feb 2007 16:42:39 +0900
From: Horms <horms@verge.net.au>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: Judith Lebzelter <judith@osdl.org>, fastboot@osdl.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kexec: fix references to init in documentation for kexe
Message-ID: <20070207074238.GG26314@verge.net.au>
References: <20070201181955.GE5825@shell0.pdx.osdl.net> <Pine.LNX.4.61.0702011923530.13737@yvahk01.tjqt.qr> <Pine.LNX.4.64.0702011329550.16875@CPE00045a9c397f-CM001225dbafb6> <Pine.LNX.4.61.0702011932090.13737@yvahk01.tjqt.qr> <20070201184217.GF5825@shell0.pdx.osdl.net> <20070201185808.GG5825@shell0.pdx.osdl.net> <20070202080240.GC6353@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202080240.GC6353@in.ibm.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 01:32:40PM +0530, Vivek Goyal wrote:
> On Thu, Feb 01, 2007 at 10:58:08AM -0800, Judith Lebzelter wrote:
> > > 
> > > I did notice that my patch is out of date for the latest kernel, 
> > > however.  I can send an up to date one.
> > > 
> > This applies to 2.6.20-rc7
> > 
> > Signed-off-by: Judith Lebzeelter <judith@osdl.org>
> > ---
> > 
> > Stop recommending incorrect/superfluous "init" boot parameter.
> > 
> 
> This looks good. The intention here is just to boot into run level 1, so
> that minimum scripts run in user space and probability of capturing the
> dump increases.
> 
> Fedora doc does say that appending "1" on command line will boot it
> into runlevel 1. I hope same is true for other distributions too.
> 
> Thanks
> Vivek

This seems fine to me. Lets see if we can get it included.

-- 
Simon Horman (Horms)
  horms@verge.net.au
  http://verge.net.au/~horms/

kexec: fix references to init in documentation for kexec

I've noticed that the boot options are not correct for in
the documentation for kdump. The "init" keyword is not
necessary, and causes a kernel panic when booting with an
initrd on Fedora 5.

Signed-off-by: Judith Lebzeelter <judith@osdl.org>
Acked-by: Vivek Goyal <vgoyal@in.ibm.com>

Put original comment with the latest version of the patch

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6.20-rc7/Documentation/kdump/kdump.txt
===================================================================
--- linux-2.6.20-rc7.orig/Documentation/kdump/kdump.txt
+++ linux-2.6.20-rc7/Documentation/kdump/kdump.txt
@@ -311,10 +311,10 @@ Following are the arch specific command 
 loading dump-capture kernel.
 
 For i386, x86_64 and ia64:
-	"init 1 irqpoll maxcpus=1"
+	"1 irqpoll maxcpus=1"
 
 For ppc64:
-	"init 1 maxcpus=1 noirqdistrib"
+	"1 maxcpus=1 noirqdistrib"
 
 
 Notes on loading the dump-capture kernel:
@@ -332,8 +332,8 @@ Notes on loading the dump-capture kernel
 * You must specify <root-dev> in the format corresponding to the root
   device name in the output of mount command.
 
-* "init 1" boots the dump-capture kernel into single-user mode without
-  networking. If you want networking, use "init 3."
+* Boot parameter "1" boots the dump-capture kernel into single-user 
+  mode without networking. If you want networking, use "3".
 
 * We generally don' have to bring up a SMP kernel just to capture the
   dump. Hence generally it is useful either to build a UP dump-capture

