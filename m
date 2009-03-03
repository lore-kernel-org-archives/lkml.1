Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbZCCQKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbZCCQKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 11:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZCCQKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 11:10:47 -0500
Received: from mx1.emlix.com ([193.175.82.87]:54122 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbZCCQKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 11:10:46 -0500
User-Agent: quilt/0.46-1
Date: Tue, 03 Mar 2009 16:30:43 +0100
From: Johannes Weiner <jw@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/3] xtensa generic time
Message-Id: <E1LeXCe-0006wA-5k@mailer.emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are three patches that convert the xtensa arch code to make use
of the generic time implementation.

The first one just removes xtensa's sched_clock() in order to use the
default implementation as it is the same thing.

The second one removes the platform-specific rtc get/set callbacks,
the interface is not really feasible for the generic time
implementation.  Currently, no platform implements this callback.
Platforms that want to should implement a rtc driver and
read_persistent_clock().

The third one converts xtensa to use generic time code by implementing
ccount as a clocksource.  This lets us get rid of xtensa-specific
gtod/stod as now the generic time code is used for that.

	Hannes

 arch/xtensa/Kconfig                |    3 +
 arch/xtensa/include/asm/platform.h |   11 ---
 arch/xtensa/kernel/platform.c      |    2 -
 arch/xtensa/kernel/time.c          |  120 +++++-------------------------------
 4 files changed, 19 insertions(+), 117 deletions(-)

