Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbZHFXbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbZHFXbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZHFXbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:31:16 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44626 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbZHFXbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:31:15 -0400
X-Sasl-enc: idFTCKsf7R5XnIgPbm1hIt99fKV4nleuZSIKX4Pyuqov 1249601475
Date: Thu, 6 Aug 2009 20:31:11 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, len.brown@intel.com,
       ranma+kernel@tdiedrich.de, stable@kernel.org
Subject: Re: patch
 thinkpad-acpi-fix-incorrect-use-of-tpacpi_brght_mode_ecnvram.patch added
 to 2.6.30-stable tree
Message-ID: <20090806233111.GB14381@khazad-dum.debian.net>
References: <20090805205011.57FB548DF1@coco.kroah.org>
 <200908070108.15095.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908070108.15095.s.L-H@gmx.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Aug 2009, Stefan Lippers-Hollmann wrote:
> This patch fails to compile if applied to 2.6.30 + current stable queue.
[...]
> It seems to depend on the new quirk handling, introduced in:
> commit 7d95a3d564901e88ed42810f054e579874151999

Good catch.  And I _will_ need that quirk handling stuff to keep 2.6.30 in
shape :-(

The dependencies for the "thinkpad-acpi: fix incorrect use of
TPACPI_BRGHT_MODE_ECNVRAM" patch are:

commit 050df107c408a3df048524b3783a5fc6d4dccfdb
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat May 30 13:25:05 2009 -0300

    thinkpad-acpi: store fw version with strict checking

    Extend the thinkpad model and firmware identification data with the
    release serial number for the BIOS and firmware (when available), as
    that is easier to parse and compare than the version strings.

    We're going to greatly extend the use of the ThinkPad DMI data through
    quirk lists, so it is best to be quite strict and make sure what we
    get from DMI is exactly what we expect, otherwise quirk matching may
    result in quite insane things.

    IBM (and Lenovo, at least for the ThinkPad line) uses this schema for
    firmware versioning and model:

    Firmware model: Two digits, [0-9A-Z]

    Firmware version: AABBCCDD, where
      AA = firmware model, see above
      BB = "ET" for BIOS, "HT" for EC
      CC = release version, two digits, [0-9A-Z],
           "00" < "09" < "0A" < "10" < "A0" < "ZZ"
      DD = "WW"

    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

And, as identified by Stefan,

commit 7d95a3d564901e88ed42810f054e579874151999
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Sat May 30 13:25:06 2009 -0300

    thinkpad-acpi: add quirklist engine

    Add a quirklist engine suitable for matching ThinkPad firmware,
    and change the code to use it.

    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Signed-off-by: Len Brown <len.brown@intel.com>

I cherry picked the commits on the order below, on top of v2.6.30.4 and it
compiled properly (and visual inspection of the result shows it is fine):

050df107c408a3df048524b3783a5fc6d4dccfdb
7d95a3d564901e88ed42810f054e579874151999
59fe4fe34d7afdf63208124f313be9056feaa2f4

Now, commit 7d95a3d564901e88ed42810f054e579874151999 could be reduced a bit
for -stable if you guys prefer (only the first hunk is really necessary),
but that would just make things more complicated later on if I find myself
in need to patch anything in the fan control subdriver for 2.6.30.y
(unlikely, but still...)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
