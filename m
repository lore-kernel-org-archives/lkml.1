Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZFCVXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZFCVXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZFCVW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:22:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:37129 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753800AbZFCVW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:22:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,300,1241420400"; 
   d="scan'208";a="521547763"
Message-ID: <4A26E9B4.4020207@intel.com>
Date: Wed, 03 Jun 2009 14:23:00 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081103)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: BUG: writing '0' to queue/rotational causes system hang
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I stumbled into the following bug on an Acer Aspire 1 running moblin2-beta: The
drive misidentifies itself as being 'rotational' even though it's an SSD drive.
drive/model = "SSDPAMM0008G1EA" - the standard 8gb SSD provided with Acer Aspire
one models.

Tuning 'rotational' to '0' at boot time causes the system to hard lock up. We're
attempting to do this tuning early in the boot phase in order to get the right
queueing and possibly improve startup time, so there is a lot of IO going on at
the moment.

Not sure what the real cause it so far. Test case is a simple "echo 0 >
/sys/block/sda/queue/rotational". Doing this at idle time has no effect, so I
suspect a race with the IO scheduler.


Cheers,

Auke

