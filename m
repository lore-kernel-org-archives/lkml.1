Return-Path: <linux-kernel-owner+w=401wt.eu-S1752510AbYJRTET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbYJRTET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYJRTCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:02:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:47202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbYJRTCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:02:49 -0400
Date: Sat, 18 Oct 2008 11:34:01 -0700
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
       alan@lxorguk.ukuu.org.uk, Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [patch 03/17] Driver core: Fix cleanup in device_create_vargs().
Message-ID: <20081018183401.GD14035@suse.de>
References: <20081018182721.521723254@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="driver-core-fix-cleanup-in-device_create_vargs.patch"
In-Reply-To: <20081018183334.GA14035@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Cornelia Huck <cornelia.huck@de.ibm.com>

commit 286661b3777897220ecfcd774bccc68a34667f39 upstream

If device_register() in device_create_vargs() fails, the device
must be cleaned up with put_device() (which is also fine on NULL)
instead of kfree().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1243,7 +1243,7 @@ struct device *device_create_vargs(struc
 	return dev;
 
 error:
-	kfree(dev);
+	put_device(dev);
 	return ERR_PTR(retval);
 }
 EXPORT_SYMBOL_GPL(device_create_vargs);

-- 
