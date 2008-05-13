Return-Path: <linux-kernel-owner+w=401wt.eu-S1763601AbYEMUXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763601AbYEMUXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932205AbYEMUQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:16:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:38698 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200AbYEMUQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:16:09 -0400
Date: Tue, 13 May 2008 13:12:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Leonardo Chiquitto <lchiquitto@novell.com>
Subject: [patch 28/37] USB: airprime: unlock mutex instead of trying to
	lock it again
Message-ID: <20080513201236.GC31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-airprime-unlock-mutex-instead-of-trying-to-lock-it-again.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Leonardo Chiquitto <leonardo@iken.com.br>

commit 21ae1dd1d4948968ad2d923c5e104d38fb35b4e4 upstream

The following patch fixes a [probable] copy & paste mistake in
airprime.c. Instead of unlocking an acquired mutex, the actual
code tries to lock it again.

Signed-off-by: Leonardo Chiquitto <lchiquitto@novell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/airprime.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/airprime.c
+++ b/drivers/usb/serial/airprime.c
@@ -220,7 +220,7 @@ static void airprime_close(struct usb_se
 	mutex_lock(&port->serial->disc_mutex);
 	if (!port->serial->disconnected)
 		airprime_send_setup(port);
-	mutex_lock(&port->serial->disc_mutex);
+	mutex_unlock(&port->serial->disc_mutex);
 
 	for (i = 0; i < NUM_READ_URBS; ++i) {
 		usb_kill_urb (priv->read_urbp[i]);

-- 
