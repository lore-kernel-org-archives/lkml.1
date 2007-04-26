Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbXDZRCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbXDZRCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbXDZRBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:01:46 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39753 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbXDZRB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:01:27 -0400
Date: Thu, 26 Apr 2007 09:57:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
       Tommi Kyntola <tommi.kyntola@ray.fi>, Jaroslav Kysela <perex@suse.cz>
Subject: [patch 30/33] ALSA: intel8x0 - Fix speaker output after S2RAM
Message-ID: <20070426165711.GE1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-intel8x0-fix-speaker-output-after-s2ram.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tommi Kyntola <tommi.kyntola@ray.fi>

[ALSA] intel8x0 - Fix speaker output after S2RAM

Fixed the mute speaker problem after S2RAM on some laptops:
	http://bugme.osdl.org/show_bug.cgi?id=6181

Signed-off-by: Tommi Kyntola <tommi.kyntola@ray.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 sound/pci/intel8x0.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -2489,7 +2489,10 @@ static int intel8x0_suspend(struct pci_d
 	}
 	pci_disable_device(pci);
 	pci_save_state(pci);
-	pci_set_power_state(pci, pci_choose_state(pci, state));
+	/* The call below may disable built-in speaker on some laptops
+	 * after S2RAM.  So, don't touch it.
+	 */
+	/* pci_set_power_state(pci, pci_choose_state(pci, state)); */
 	return 0;
 }
 

-- 
