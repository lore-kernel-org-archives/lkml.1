Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbXBUBwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbXBUBwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964934AbXBUBwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:52:35 -0500
Received: from ns2.suse.de ([195.135.220.15]:35840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965318AbXBUBwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:52:18 -0500
Date: Tue, 20 Feb 2007 17:50:55 -0800
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jean Delvare <khali@linux-fr.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch 12/18] v4l: cx88: Fix leadtek_eeprom tagging
Message-ID: <20070221015055.GM3684@kroah.com>
References: <20070221014413.282048309@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="v4l-cx88-Fix-leadtek_eeprom-tagging.patch"
In-Reply-To: <20070221014927.GA3684@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jean Delvare <khali@linux-fr.org>

reference to .init.text: from .text between 'cx88_card_setup'
(at offset 0x68c) and 'cx88_risc_field'
Caused by leadtek_eeprom() being declared __devinit and called from
a non-devinit context.

(cherry picked from commit 69f7e75a9d45e5eaca16917a8d0dedf76149f13f)

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx88/cx88-cards.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.18.7.orig/drivers/media/video/cx88/cx88-cards.c
+++ linux-2.6.18.7/drivers/media/video/cx88/cx88-cards.c
@@ -1465,7 +1465,7 @@ const unsigned int cx88_idcount = ARRAY_
 /* ----------------------------------------------------------------------- */
 /* some leadtek specific stuff                                             */
 
-static void __devinit leadtek_eeprom(struct cx88_core *core, u8 *eeprom_data)
+static void leadtek_eeprom(struct cx88_core *core, u8 *eeprom_data)
 {
 	/* This is just for the "Winfast 2000XP Expert" board ATM; I don't have data on
 	 * any others.

--
