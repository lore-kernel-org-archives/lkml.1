Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYLCT72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYLCT72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:59:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYLCTuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:40 -0500
Received: from kroah.org ([198.145.64.141]:59653 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754667AbYLCTua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:30 -0500
Date: Wed, 3 Dec 2008 11:49:08 -0800
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 022/104] parport_serial: fix array overflow
Message-ID: <20081203194908.GW8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="parport_serial-fix-array-overflow.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Takashi Iwai <tiwai@suse.de>

commit 36be47d6d8d98f54b6c4f891e9f54fb2bf554584 upstream.

The netmos_9xx5_combo type assumes that PCI SSID provides always the
correct value for the number of parallel and serial ports, but there are
indeed broken devices with wrong numbers, which may result in Oops.

This patch simply adds the check of the array range.

Reference: Novell bnc#447067
	https://bugzilla.novell.com/show_bug.cgi?id=447067

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/parport/parport_serial.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -70,6 +70,8 @@ static int __devinit netmos_parallel_ini
 	 * parallel ports and <S> is the number of serial ports.
 	 */
 	card->numports = (dev->subsystem_device & 0xf0) >> 4;
+	if (card->numports > ARRAY_SIZE(card->addr))
+		card->numports = ARRAY_SIZE(card->addr);
 	return 0;
 }
 

