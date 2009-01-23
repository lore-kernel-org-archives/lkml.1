Return-Path: <linux-kernel-owner+w=401wt.eu-S1763159AbZAWB0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763159AbZAWB0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 20:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760112AbZAWBPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 20:15:31 -0500
Received: from kroah.org ([198.145.64.141]:50720 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756379AbZAWBPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 20:15:08 -0500
Date: Thu, 22 Jan 2009 17:12:37 -0800
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
       alan@lxorguk.ukuu.org.uk, Pavel Roskin <proski@gnu.org>
Subject: [patch 31/46] dell_rbu: use scnprintf() instead of less secure
	sprintf()
Message-ID: <20090123011237.GF19756@kroah.com>
References: <20090123010651.683741823@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dell_rbu-use-scnprintf-instead-of-less-secure-sprintf.patch"
In-Reply-To: <20090123011110.GA19756@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Roskin <proski@gnu.org>

commit 81156928f8fe31621e467490b9d441c0285998c3 upstream.

Reading 0 bytes from /sys/devices/platform/dell_rbu/image_type or
/sys/devices/platform/dell_rbu/packet_size by an ordinary user causes an
oops.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firmware/dell_rbu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firmware/dell_rbu.c
+++ b/drivers/firmware/dell_rbu.c
@@ -576,7 +576,7 @@ static ssize_t read_rbu_image_type(struc
 {
 	int size = 0;
 	if (!pos)
-		size = sprintf(buffer, "%s\n", image_type);
+		size = scnprintf(buffer, count, "%s\n", image_type);
 	return size;
 }
 
@@ -648,7 +648,7 @@ static ssize_t read_rbu_packet_size(stru
 	int size = 0;
 	if (!pos) {
 		spin_lock(&rbu_data.lock);
-		size = sprintf(buffer, "%lu\n", rbu_data.packetsize);
+		size = scnprintf(buffer, count, "%lu\n", rbu_data.packetsize);
 		spin_unlock(&rbu_data.lock);
 	}
 	return size;

