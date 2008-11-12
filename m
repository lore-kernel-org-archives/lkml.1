Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbYKLAnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbYKLAnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYKLA1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:27:10 -0500
Received: from kroah.org ([198.145.64.141]:42726 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753934AbYKLA1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:27:06 -0500
Date: Tue, 11 Nov 2008 16:24:41 -0800
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
       alan@lxorguk.ukuu.org.uk, Paul Stoffregen <paul@pjrc.com>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [patch 49/49] HID: fix incorrent length condition in hidraw_write()
Message-ID: <20081112002441.GX10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hid-fix-incorrent-length-condition-in-hidraw_write.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

upstream commit 2b107d629dc0c35de606bb7b010b829cd247a93a

From: Jiri Kosina <jkosina@suse.cz>

The bound check on the buffer length

	if (count > HID_MIN_BUFFER_SIZE)

is of course incorrent, the proper check is

	if (count > HID_MAX_BUFFER_SIZE)

Fix it.

Reported-by: Jerry Ryle <jerry@mindtribe.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Paul Stoffregen <paul@pjrc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hidraw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -113,7 +113,7 @@ static ssize_t hidraw_write(struct file 
 	if (!dev->hid_output_raw_report)
 		return -ENODEV;
 
-	if (count > HID_MIN_BUFFER_SIZE) {
+	if (count > HID_MAX_BUFFER_SIZE) {
 		printk(KERN_WARNING "hidraw: pid %d passed too large report\n",
 				task_pid_nr(current));
 		return -EINVAL;

-- 
