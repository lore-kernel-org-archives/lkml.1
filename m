Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbYKGX0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbYKGX0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYKGXXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:23:05 -0500
Received: from kroah.org ([198.145.64.141]:59266 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753743AbYKGXXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:23:01 -0500
Date: Fri, 7 Nov 2008 15:15:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Boris Dores <babal@via.ecp.fr>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Mike Isely <isely@pobox.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [patch 10/23] V4L: pvrusb2: Keep MPEG PTSs from drifting away
Message-ID: <20081107231543.GK1108@kroah.com>
References: <20081107224818.593212310@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-pvrusb2-keep-mpeg-ptss-from-drifting-away.patch"
In-Reply-To: <20081107231457.GA1108@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Boris Dores <babal@via.ecp.fr>

commit 3f93d1adca658201c64251c43a147cc79d468c3f upstream.

V4L: pvrusb2: Keep MPEG PTSs from drifting away

This change was empirically figured out by Boris Dores after
empirically comparing against behavior in the Windows driver.

Signed-off-by: Mike Isely <isely@pobox.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/pvrusb2/pvrusb2-encoder.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/video/pvrusb2/pvrusb2-encoder.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-encoder.c
@@ -403,6 +403,10 @@ static int pvr2_encoder_prep_config(stru
 	ret |= pvr2_encoder_vcmd(hdw, CX2341X_ENC_MISC,4, 0,3,0,0);
 	ret |= pvr2_encoder_vcmd(hdw, CX2341X_ENC_MISC,4,15,0,0,0);
 
+	/* prevent the PTSs from slowly drifting away in the generated
+	   MPEG stream */
+	ret |= pvr2_encoder_vcmd(hdw, CX2341X_ENC_MISC, 2, 4, 1);
+
 	return ret;
 }
 

-- 
