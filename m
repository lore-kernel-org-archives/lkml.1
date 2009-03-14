Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbZCNAcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbZCNAcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZCNATJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:09 -0400
Received: from kroah.org ([198.145.64.141]:46892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752974AbZCNASs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:43 2009
Message-Id: <20090314000743.150862465@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:36 -0700
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
       alan@lxorguk.ukuu.org.uk, Anssi Hannula <anssi.hannula@gmail.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 28/96] ALSA: aw2: do not grab every saa7146 based device
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=alsa-aw2-do-not-grab-every-saa7146-based-device.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anssi Hannula <anssi.hannula@gmail.com>

commit e8bf069c419c1dc0657e02636441fe1179a9db14 upstream.

Audiowerk2 driver snd-aw2 is bound to any saa7146 device as it does not
check subsystem ids. Many DVB devices are saa7146 based, so aw2 driver
grabs them as well.

According to http://lkml.org/lkml/2008/10/15/311 aw2 devices have the
subsystem ids set to 0, the saa7146 default.

Fix conflicts with DVB devices by checking for subsystem ids = 0
specifically.

Signed-off-by: Anssi Hannula <anssi.hannula@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/aw2/aw2-alsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/aw2/aw2-alsa.c
+++ b/sound/pci/aw2/aw2-alsa.c
@@ -165,7 +165,7 @@ module_param_array(enable, bool, NULL, 0
 MODULE_PARM_DESC(enable, "Enable Audiowerk2 soundcard.");
 
 static struct pci_device_id snd_aw2_ids[] = {
-	{PCI_VENDOR_ID_SAA7146, PCI_DEVICE_ID_SAA7146, PCI_ANY_ID, PCI_ANY_ID,
+	{PCI_VENDOR_ID_SAA7146, PCI_DEVICE_ID_SAA7146, 0, 0,
 	 0, 0, 0},
 	{0}
 };


