Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZJKJFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZJKJFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZJKJFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:05:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56612 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbZJKJFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:05:52 -0400
Date: Sun, 11 Oct 2009 11:05:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <gregkh@suse.de>
Cc: David Rientjes <rientjes@google.com>, Greg KH <greg@kroah.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>,
       Arve Hjonnevag <arve@android.com>, San Mehat <san@android.com>
Subject: Re: [PATCH] linux-next: 20090929 - android driver build breaks
Message-ID: <20091011090508.GC1414@ucw.cz>
References: <20090929140404.dfb2c5f5.sfr@canb.auug.org.au> <20090929152027.GC4373@linux.vnet.ibm.com> <20091008224725.GA22949@kroah.com> <alpine.DEB.1.00.0910081621340.10613@chino.kir.corp.google.com> <20091008232825.GA540@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008232825.GA540@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > If it's a criticism of the staleness of the Android code within the 
> > staging tree or no recent activity, then we should probably loop in some 
> > Android developers to find our about their plans.  I've added them to the 
> > cc.
> 
> They know all about this and agreed that the code should be dropped for
> 2.6.33 if no one sends me patches.  If someone does, then I will remove
> my 'delete the android code' patch in the staging tree.
> 
> Honestly, I'm not holding my breath :(

Heh, I'm glad, I did not make dream suppport dependend on
CONFIG_ANDROID... :-).

Oops, no, it does depend on it. 

Something like this?
									Pavel
---

Make Dream support idenependend of CONFIG_ANDROID.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- linux-rc/drivers/staging.ofic/Makefile	2009-10-06 13:51:49.000000000 +0200
+++ linux-rc/drivers/staging/Makefile	2009-10-10 14:52:36.000000000 +0200
@@ -27,7 +27,7 @@
 obj-$(CONFIG_INPUT_MIMIO)	+= mimio/
 obj-$(CONFIG_TRANZPORT)		+= frontier/
 obj-$(CONFIG_ANDROID)		+= android/
-obj-$(CONFIG_ANDROID)		+= dream/
+obj-$(CONFIG_DREAM)		+= dream/
 obj-$(CONFIG_DST)		+= dst/
 obj-$(CONFIG_POHMELFS)		+= pohmelfs/
 obj-$(CONFIG_STLC45XX)		+= stlc45xx/
--- linux-rc/drivers/staging.ofic/dream/Kconfig	2009-10-06 13:52:05.000000000 +0200
+++ linux-rc/drivers/staging/dream/Kconfig	2009-10-10 14:53:11.000000000 +0200
@@ -1,3 +1,6 @@
+config DREAM
+       tristate "HTC Dream support"
+
 source "drivers/staging/dream/smd/Kconfig"
 
 source "drivers/staging/dream/camera/Kconfig"



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
