Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbYICRfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbYICRfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbYICRel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:34:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788AbYICRek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:34:40 -0400
Date: Wed, 3 Sep 2008 10:25:34 -0700
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
       alan@lxorguk.ukuu.org.uk, Stefan Weinhuber <wein@de.ibm.com>
Subject: [patch 09/42] S390 dasd: fix data size for PSF/PRSSD command
Message-ID: <20080903172534.GJ7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="s390-dasd-fix-data-size-for-psf-prssd-command.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stefan Weinhuber <wein@de.ibm.com>

commit 49fd38bdaa96f093fcad3176a781a4d0de8f8602 upstream

The Perform Subsystem Function/Prepare for Read Subsystem Data
command requires 12 bytes of parameter data, but the respective data
structure dasd_psf_prssd_data has a length of 16 bytes.
Current storage servers ignore the obsolete bytes, but older models
fail to execute the command and report an incorrect length error.
This causes the device initilization for these devices to fail.
To fix this problem we need to correct the dasd_psf_prssd_data
structure and shorten it to the correct length.

Reported-by: Ivan Warren <ivan@vmfacility.fr>
Reviewed-by: Ivan Warren <ivan@vmfacility.fr>
Tested-by: Ivan Warren <ivan@vmfacility.fr>
Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/block/dasd_eckd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/block/dasd_eckd.h
+++ b/drivers/s390/block/dasd_eckd.h
@@ -379,7 +379,7 @@ struct dasd_psf_prssd_data {
 	unsigned char flags;
 	unsigned char reserved[4];
 	unsigned char suborder;
-	unsigned char varies[9];
+	unsigned char varies[5];
 } __attribute__ ((packed));
 
 /*

-- 
