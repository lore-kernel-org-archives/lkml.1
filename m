Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYKDXil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYKDXil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYKDXhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:37:41 -0500
Received: from ns2.suse.de ([195.135.220.15]:51793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745AbYKDXhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:37:40 -0500
Date: Tue, 4 Nov 2008 15:31:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andi Kleen <ak@linux.intel.com>
Subject: [patch 04/57] sysfs: Fix return values for sysdev_store_{ulong,
	int}
Message-ID: <20081104233104.GE659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sysfs-fix-return-values-for-sysdev_store_-ulong-int.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Andi Kleen <andi@firstfloor.org>

commit 4e318d7c6c9dd5cdae48bcf61558bbc0c09b12ac upstream

SYSFS: Fix return values for sysdev_store_{ulong,int}

Always return the full size instead of the consumed
length of the string in sysdev_store_{ulong,int}

This avoids EINVAL errors in some echo versions.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/sys.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -488,7 +488,8 @@ ssize_t sysdev_store_ulong(struct sys_de
 	if (end == buf)
 		return -EINVAL;
 	*(unsigned long *)(ea->var) = new;
-	return end - buf;
+	/* Always return full write size even if we didn't consume all */
+	return size;
 }
 EXPORT_SYMBOL_GPL(sysdev_store_ulong);
 
@@ -511,7 +512,8 @@ ssize_t sysdev_store_int(struct sys_devi
 	if (end == buf || new > INT_MAX || new < INT_MIN)
 		return -EINVAL;
 	*(int *)(ea->var) = new;
-	return end - buf;
+	/* Always return full write size even if we didn't consume all */
+	return size;
 }
 EXPORT_SYMBOL_GPL(sysdev_store_int);
 

-- 
