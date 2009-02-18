Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbZBRXFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbZBRXFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 18:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758418AbZBRXEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 18:04:53 -0500
Received: from mbox2.netikka.net ([213.250.81.203]:60711 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbZBRXEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 18:04:52 -0500
Message-ID: <499C9394.5030704@mandriva.org>
Date: Thu, 19 Feb 2009 01:02:44 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [patch 03/36] Fix Intel IOMMU write-buffer flushing
References: <20090218222447.432108614@mini.kroah.org> <20090218222901.GD10668@kroah.com>
In-Reply-To: <20090218222901.GD10668@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------040804040706010700020307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040804040706010700020307
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch is broken compared to what's in:
http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ca77fde8e62cecb2c0769052228d15b901367af8

attached patch fixes it

--
Thomas

--------------040804040706010700020307
Content-Type: text/plain;
 name="fix_intel-iommu_build.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix_intel-iommu_build.patch"

[thomas@tmb linux-2.6.27.18.test]$ LC_ALL=C make drivers/pci/
CHK     include/linux/version.h
CHK     include/linux/utsrelease.h
CALL    scripts/checksyscalls.sh
CC      drivers/pci/intel-iommu.o
drivers/pci/intel-iommu.c: In function 'iommu_flush_write_buffer':
drivers/pci/intel-iommu.c:530: error: 'rwbf_quirk' undeclared (first use in this function)
drivers/pci/intel-iommu.c:530: error: (Each undeclared identifier is reported only once
drivers/pci/intel-iommu.c:530: error: for each function it appears in.)
make[1]: *** [drivers/pci/intel-iommu.o] Error 1
make: *** [drivers/pci/] Error 2

Signed-off-by: Thomas Backlund <tmb@mandriva.org>

--- linux-2.6.27.18.test/drivers/pci/intel-iommu.c.orig	2009-02-19 00:50:49.000000000 +0200
+++ linux-2.6.27.18.test/drivers/pci/intel-iommu.c	2009-02-19 00:59:43.000000000 +0200
@@ -72,6 +72,8 @@ static struct deferred_flush_tables *def
 /* bitmap for indexing intel_iommus */
 static int g_num_of_iommus;
 
+static int rwbf_quirk = 0;
+
 static DEFINE_SPINLOCK(async_umap_flush_lock);
 static LIST_HEAD(unmaps_to_do);
 
@@ -1410,8 +1412,6 @@ static void domain_remove_dev_info(struc
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 }
 
-static int rwbf_quirk = 0;
-
 /*
  * find_domain
  * Note: we use struct pci_dev->dev.archdata.iommu stores the info

--------------040804040706010700020307--
