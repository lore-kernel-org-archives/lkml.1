Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbZGaAj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbZGaAj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 20:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164AbZGaAj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 20:39:58 -0400
Received: from ru.mvista.com ([213.79.90.228]:33233 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752142AbZGaAj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 20:39:57 -0400
Date: Fri, 31 Jul 2009 04:39:57 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben@fluff.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jean Delvare <khali@linux-fr.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH v2 0/6] Device table matching for SPI subsystem
Message-ID: <20090731003957.GA23982@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

This new patch set overwrites following patches:

  hwmon-lm70-convert-to-device-table-matching.patch
  hwmon-adxx-convert-to-device-table-matching.patch
  spi-merge-probe-and-probe_id-callbacks.patch
  spi-prefix-modalias-with-spi.patch
  of-remove-stmm25p40-alias.patch
  mtd-m25p80-convert-to-device-table-matching.patch
  spi-add-support-for-device-table-matching.patch


Changes since v1:

- Implemented Ben Dooks' idea of spi_get_device_id(), so we won't
  call spi_match_id() twice for drivers that don't need the id.

- "spi: Merge probe and probe_id callbacks" patch no longer needed
  as we don't change probe()'s arguments;

- Rename spi_device_id->data to driver_data, and turn it into
  kernel_ulong_t to match majority of subsystems. Most drivers
  don't need a pointer type anyway (e.g. m25p80 needs it, but
  lm70 and adcxx don't);

- SPI_NAME_SIZE now defined to 32 (as it should be, using 20
  for name size was a cut-n-paste typo from I2C defines).


Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
