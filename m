Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbXH1XaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbXH1XaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXH1XaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:30:14 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:55205 "EHLO
	viefep23-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751123AbXH1XaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:30:12 -0400
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.23-rc4: BAD regression
Date: Wed, 29 Aug 2007 01:29:56 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708290129.57243.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tried that one on my old toshiba tecra 8000 laptop, almost killing it.
the fan doesn't work any more...type 'make' and see the box dying.
luckily my CPU doesn't commit suicide...bisected it to that one:

cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b is first bad commit
commit cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Fri Aug 3 17:52:48 2007 -0400

    ACPI: EC: If ECDT is not found, look up EC in DSDT.

    Some ASUS laptops access EC space from device _INI methods, but do not
    provide ECDT for early EC setup. In order to make them function properly,
    there is a need to find EC is DSDT before any _INI is called.

    Similar functionality was turned on by acpi_fake_ecdt=1 command line
    before. Now it is on all the time.

    http://bugzilla.kernel.org/show_bug.cgi?id=8598

    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Len Brown <len.brown@intel.com>
