Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZG2RDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZG2RDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 13:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbZG2RDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 13:03:46 -0400
Received: from ru.mvista.com ([213.79.90.228]:28615 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755687AbZG2RDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 13:03:46 -0400
Date: Wed, 29 Jul 2009 21:03:45 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 0/7] Device table matching for SPI subsystem
Message-ID: <20090729170345.GA26787@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This patch set implements standard device table matching mechanism
for SPI subsystem, the same device id tables as we use in I2C drivers.

I started this work because m25p80 driver misdetects non-JEDEC
chips when it is used on OpenFirmware platforms (cause we don't pass
platform_data). platform_data is overkill for m25p80 chips, the
driver only needs to know exact chip model, and that's what device
tables are for.

So the patches:

  [1/7] spi: Add support for device table matching
  [2/7] mtd: m25p80: Convert to device table matching
  [3/7] of: Remove "stm,m25p40" alias

The three patches above do real work. I tried to keep the 1/7 patch as
small as possible, and factor out the subsystem cleanups into other,
"cleanup" patches:

  [PATCH 4/7] spi: Prefix modalias with "spi:"
  [PATCH 5/7] spi: Merge probe and probe_id callbacks

These two patches I consider as cleanups, they should not introduce
any behavioural change, but they touch quite a lot of files.

  [PATCH 6/7] hwmon: adxx: Convert to device table matching
  [PATCH 7/7] hwmon: lm70: Convert to device table matching

These two are here because I couldn't stop. :-) Also cleanups.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
