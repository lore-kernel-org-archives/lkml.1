Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbYKDXo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbYKDXo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757002AbYKDXiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:47388 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293AbYKDXit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:49 -0500
Date: Tue, 4 Nov 2008 15:31:41 -0800
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
Subject: [patch 21/57] firewire: fix ioctl() return code
Message-ID: <20081104233141.GV659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="firewire-fix-ioctl-return-code.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

commit 99692f71ee04c6f249d0bf6a581359f32f409a38 upstream

Reported by Jay Fenlason:  ioctl() did not return as intended
  - the size of data read into ioctl_send_request,
  - the number of datagrams enqueued by ioctl_queue_iso.


Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firewire/fw-cdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firewire/fw-cdev.c
+++ b/drivers/firewire/fw-cdev.c
@@ -913,7 +913,7 @@ dispatch_ioctl(struct client *client, un
 			return -EFAULT;
 	}
 
-	return 0;
+	return retval;
 }
 
 static long

-- 
