Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbYKDXoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbYKDXoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756775AbYKDXiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:51982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756911AbYKDXip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:45 -0500
Date: Tue, 4 Nov 2008 15:31:39 -0800
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
       alan@lxorguk.ukuu.org.uk, linux1394-devel@lists.sourceforge.net,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [patch 20/57] firewire: fix setting tag and sy in iso transmission
Message-ID: <20081104233139.GU659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-fix-setting-tag-and-sy-in-iso-transmission.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 7a1003449c693f0d57443c8786bbf19717921ae0 upstream

Reported by Jay Fenlason:
The iso packet control accessors in fw-cdev.c had bogus masks.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-cdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -720,8 +720,8 @@ static int ioctl_create_iso_context(stru
 #define GET_PAYLOAD_LENGTH(v)	((v) & 0xffff)
 #define GET_INTERRUPT(v)	(((v) >> 16) & 0x01)
 #define GET_SKIP(v)		(((v) >> 17) & 0x01)
-#define GET_TAG(v)		(((v) >> 18) & 0x02)
-#define GET_SY(v)		(((v) >> 20) & 0x04)
+#define GET_TAG(v)		(((v) >> 18) & 0x03)
+#define GET_SY(v)		(((v) >> 20) & 0x0f)
 #define GET_HEADER_LENGTH(v)	(((v) >> 24) & 0xff)
 
 static int ioctl_queue_iso(struct client *client, void *buffer)

-- 
