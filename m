Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZINKv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZINKv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752796AbZINKv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:51:26 -0400
Received: from iksaif.net ([88.191.73.63]:44081 "EHLO iksaif.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbZINKvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:51:24 -0400
From: Corentin Chary <corentincj@iksaif.net>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 0/3] rfkill_unregister() should always be followed by rfkill_destroy()
Date: Mon, 14 Sep 2009 12:43:50 +0200
Message-Id: <1252925033-29696-1-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semantic match that finds the first problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>

@r@
expression E;
position p;
@@

rfkill_unregister(E);@p
... when != rfkill_destroy(E)

@script:python@
p << r.p;
@@

print "rfkill_unregister without rfkill_destroy found: %s %s " % (p[0].file, p[0].line)
// </spml>

Corentin Chary (3):
  hp-wmi: fix rfkill memory leak on unload
  thinkpad_acpi: fix rfkill memory leak on unload
  dell-laptop: fix rfkill memory leak on unload

 drivers/platform/x86/dell-laptop.c   |   36 ++++++++++++++++++++++-----------
 drivers/platform/x86/hp-wmi.c        |    2 +-
 drivers/platform/x86/thinkpad_acpi.c |    1 +
 3 files changed, 26 insertions(+), 13 deletions(-)

