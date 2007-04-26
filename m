Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbXDZRBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbXDZRBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbXDZRBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:01:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39567 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbXDZRAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:00:05 -0400
Date: Thu, 26 Apr 2007 09:56:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andi Kleen <andi@firstfloor.org>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: [patch 17/33] cache_k8_northbridges() overflows beyond allocation
Message-ID: <20070426165619.GR1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cache_k8_northbridges-overflows-beyond-allocation.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Badari Pulavarty <pbadari@gmail.com>

cache_k8_northbridges() overflows beyond allocation

cache_k8_northbridges() is storing config values to incorrect locations
(in flush_words) and also its overflowing beyond the allocation, causing
slab verification failures.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86_64/kernel/k8.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86_64/kernel/k8.c
+++ b/arch/x86_64/kernel/k8.c
@@ -61,8 +61,8 @@ int cache_k8_northbridges(void)
 	dev = NULL;
 	i = 0;
 	while ((dev = next_k8_northbridge(dev)) != NULL) {
-		k8_northbridges[i++] = dev;
-		pci_read_config_dword(dev, 0x9c, &flush_words[i]);
+		k8_northbridges[i] = dev;
+		pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
 	}
 	k8_northbridges[i] = NULL;
 	return 0;

-- 
