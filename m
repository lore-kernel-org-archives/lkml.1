Return-Path: <linux-kernel-owner+w=401wt.eu-S1763903AbZAWG0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763903AbZAWG0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761225AbZAWGQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:50 -0500
Received: from kroah.org ([198.145.64.141]:36355 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761163AbZAWGQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:45 -0500
Date: Thu, 22 Jan 2009 22:14:18 -0800
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
Subject: [patch 25/40] dell_rbu: use scnprintf() instead of less secure
	sprintf()
Message-ID: <20090123061418.GY2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dell_rbu-use-scnprintf-instead-of-less-secure-sprintf.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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

