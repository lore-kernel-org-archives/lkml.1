Return-Path: <linux-kernel-owner+w=401wt.eu-S1758111AbZGRKUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbZGRKUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbZGRKUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:20:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53550 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbZGRKUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:20:39 -0400
Date: Sat, 18 Jul 2009 12:20:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: reinette chatre <reinette.chatre@intel.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: iwl3945: fix LED config option
Message-ID: <20090718102030.GA2040@elf.ucw.cz>
References: <20090619222431.GA2398@elf.ucw.cz> <1246298908.17896.391.camel@rc-desk> <20090709093859.GA10001@elf.ucw.cz> <1247153986.17896.1233.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247153986.17896.1233.camel@rc-desk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-07-09 08:39:46, reinette chatre wrote:
> On Thu, 2009-07-09 at 02:38 -0700, Pavel Machek wrote:
> > > > 
> > > > (Also wifi LED stopped working on x60, but that's older issue).
> > > 
> > > Is there a bug report for this?
> > 
> > Well... I thought that was known issue?
> > 
> > Anyway, wifi LED used to work on x60 before driver rewrite. Now it is
> > broken. I thought it is known/missing functionality? ...but I'd like
> > to get it back :-).
> 
> Sorry ... but I have to ask ... did you compile with
> CONFIG_IWLWIFI_LEDS ? If you still have issues - please do submit a bug
> report.

Aha, this explains it:

  Enable LED support in iwlagn and iwl3945 drivers (IWLWIFI_LEDS) [N/y] (NEW) ?

Sorry, no help available for this option yet.

...maybe LEDS should be default Y?
									Pavel

---

IWLWIFI_LEDS option should certainly have help comment, and should
default to y. Actually I wonder if it should be user configurable at
all, is there good reason?

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index e092af0..95d9aa5 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -9,6 +9,10 @@ config IWLWIFI
 config IWLWIFI_LEDS
 	bool "Enable LED support in iwlagn and iwl3945 drivers"
 	depends on IWLWIFI
+	default y
+	---help---
+	  Useful to get Wifi LED working at least on Thinkpad notebooks.
+
 
 config IWLWIFI_SPECTRUM_MEASUREMENT
 	bool "Enable Spectrum Measurement in iwlagn driver"


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
