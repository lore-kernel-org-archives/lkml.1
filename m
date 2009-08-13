Return-Path: <linux-kernel-owner+w=401wt.eu-S932297AbZHMUJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbZHMUJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbZHMUJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:09:48 -0400
Received: from kroah.org ([198.145.64.141]:41747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109AbZHMT7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:29 2009
Message-Id: <20090813195129.309168736@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:50:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>, Helge Deller <deller@gmx.de>
Subject: [patch 32/74] parisc: isa-eeprom - Fix loff_t usage
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=parisc-isa-eeprom-fix-loff_t-usage.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Buesch <mb@bu3sch.de>

commit 6b4dbcd86a9d464057fcc7abe4d0574093071fcc upstream.

loff_t is a signed type. If userspace passes a negative ppos, the "count"
range check is weakened. "count"s bigger than HPEE_MAX_LENGTH will pass the check.
Also, if ppos is negative, the readb(eisa_eeprom_addr + *ppos) will poke in random
memory.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/parisc/eisa_eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/parisc/eisa_eeprom.c
+++ b/drivers/parisc/eisa_eeprom.c
@@ -55,7 +55,7 @@ static ssize_t eisa_eeprom_read(struct f
 	ssize_t ret;
 	int i;
 	
-	if (*ppos >= HPEE_MAX_LENGTH)
+	if (*ppos < 0 || *ppos >= HPEE_MAX_LENGTH)
 		return 0;
 	
 	count = *ppos + count < HPEE_MAX_LENGTH ? count : HPEE_MAX_LENGTH - *ppos;


