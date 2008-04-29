Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbYD2R3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbYD2R3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758860AbYD2RVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:43267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758822AbYD2RVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:23 -0400
Date: Tue, 29 Apr 2008 10:18:45 -0700
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
       =?iso-8859-1?B?QmrDtnJu?= Steinbrink <B.Steinbrink@gmx.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [21/37] x86, pci: fix off-by-one errors in some pirq warnings
Message-ID: <20080429171845.GV14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="x86-pci-fix-off-by-one-errors-in-some-pirq-warnings.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Björn Steinbrink <B.Steinbrink@gmx.de>

commit 223ac2f42d49dd0324ca02ea15897ead1a2f5133 upstream.

fix bogus pirq warnings reported in:

  http://bugzilla.kernel.org/show_bug.cgi?id=10366

safe to be backported to v2.6.25 and earlier.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/pci/irq.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -200,7 +200,7 @@ static int pirq_ali_get(struct pci_dev *
 {
 	static const unsigned char irqmap[16] = { 0, 9, 3, 10, 4, 5, 7, 6, 1, 11, 0, 12, 0, 14, 0, 15 };
 
-	WARN_ON_ONCE(pirq >= 16);
+	WARN_ON_ONCE(pirq > 16);
 	return irqmap[read_config_nybble(router, 0x48, pirq-1)];
 }
 
@@ -209,7 +209,7 @@ static int pirq_ali_set(struct pci_dev *
 	static const unsigned char irqmap[16] = { 0, 8, 0, 2, 4, 5, 7, 6, 0, 1, 3, 9, 11, 0, 13, 15 };
 	unsigned int val = irqmap[irq];
 
-	WARN_ON_ONCE(pirq >= 16);
+	WARN_ON_ONCE(pirq > 16);
 	if (val) {
 		write_config_nybble(router, 0x48, pirq-1, val);
 		return 1;
@@ -260,7 +260,7 @@ static int pirq_via586_get(struct pci_de
 {
 	static const unsigned int pirqmap[5] = { 3, 2, 5, 1, 1 };
 
-	WARN_ON_ONCE(pirq >= 5);
+	WARN_ON_ONCE(pirq > 5);
 	return read_config_nybble(router, 0x55, pirqmap[pirq-1]);
 }
 
@@ -268,7 +268,7 @@ static int pirq_via586_set(struct pci_de
 {
 	static const unsigned int pirqmap[5] = { 3, 2, 5, 1, 1 };
 
-	WARN_ON_ONCE(pirq >= 5);
+	WARN_ON_ONCE(pirq > 5);
 	write_config_nybble(router, 0x55, pirqmap[pirq-1], irq);
 	return 1;
 }
@@ -282,7 +282,7 @@ static int pirq_ite_get(struct pci_dev *
 {
 	static const unsigned char pirqmap[4] = { 1, 0, 2, 3 };
 
-	WARN_ON_ONCE(pirq >= 4);
+	WARN_ON_ONCE(pirq > 4);
 	return read_config_nybble(router,0x43, pirqmap[pirq-1]);
 }
 
@@ -290,7 +290,7 @@ static int pirq_ite_set(struct pci_dev *
 {
 	static const unsigned char pirqmap[4] = { 1, 0, 2, 3 };
 
-	WARN_ON_ONCE(pirq >= 4);
+	WARN_ON_ONCE(pirq > 4);
 	write_config_nybble(router, 0x43, pirqmap[pirq-1], irq);
 	return 1;
 }

-- 
