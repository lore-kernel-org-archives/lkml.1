Return-Path: <linux-kernel-owner+w=401wt.eu-S1759253AbYGVXd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253AbYGVXd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758122AbYGVXXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:23:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:58298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757448AbYGVXXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:23:35 -0400
Date: Tue, 22 Jul 2008 16:17:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Pierre Ossman <drzeus@drzeus.cx>
Subject: [patch 45/47] mmc: dont use DMA on newer ENE controllers
Message-ID: <20080722231738.GT8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mmc-don-t-use-dma-on-newer-ene-controllers.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Pierre Ossman <drzeus@drzeus.cx>

commit bf5b1935d8e42b36a34645788eb261461fe07f2e upstream.

Even the newer ENE controllers have bugs in their DMA engine that make
it too dangerous to use. Disable it until someone has figured out under
which conditions it corrupts data.

This has caused problems at least once, and can be found as bug report
10925 in the kernel bugzilla.

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -109,7 +109,8 @@ static const struct pci_device_id pci_id
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.driver_data    = SDHCI_QUIRK_SINGLE_POWER_WRITE |
-				  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS,
+				  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS |
+				  SDHCI_QUIRK_BROKEN_DMA,
 	},
 
 	{
@@ -118,7 +119,8 @@ static const struct pci_device_id pci_id
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.driver_data    = SDHCI_QUIRK_SINGLE_POWER_WRITE |
-				  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS,
+				  SDHCI_QUIRK_RESET_CMD_DATA_ON_IOS |
+				  SDHCI_QUIRK_BROKEN_DMA,
 	},
 
 	{

-- 
