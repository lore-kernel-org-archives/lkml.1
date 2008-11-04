Return-Path: <linux-kernel-owner+w=401wt.eu-S1759786AbYKDXua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759786AbYKDXua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757704AbYKDXjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:39:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52107 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757696AbYKDXju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:39:50 -0500
Date: Tue, 4 Nov 2008 15:32:47 -0800
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
Subject: [patch 34/57] V4L: pvrusb2: Keep MPEG PTSs from drifting away
Message-ID: <20081104233247.GI659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-pvrusb2-keep-mpeg-ptss-from-drifting-away.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Boris Dores <babal@via.ecp.fr>

cherry picked from commit 3f93d1adca658201c64251c43a147cc79d468c3f

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
@@ -402,6 +402,10 @@ static int pvr2_encoder_prep_config(stru
 	ret |= pvr2_encoder_vcmd(hdw, CX2341X_ENC_MISC,4, 0,3,0,0);
 	ret |= pvr2_encoder_vcmd(hdw, CX2341X_ENC_MISC,4,15,0,0,0);
 
+	/* prevent the PTSs from slowly drifting away in the generated
+	   MPEG stream */
+	ret |= pvr2_encoder_vcmd(hdw, CX2341X_ENC_MISC, 2, 4, 1);
+
 	return ret;
 }
 

-- 
