Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbYDKUhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbYDKUhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759706AbYDKUh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:37:29 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41946 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759414AbYDKUh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:37:28 -0400
X-Sasl-enc: MEXXja5CB9kj1HwHr+omy1Tk//EB/Yj5mgIxDJsVAYJR 1207946247
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] rfkill support for r/w and r/o rfkill switches
Date: Fri, 11 Apr 2008 17:37:16 -0300
Message-Id: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series (based on v2.6.25-rc8-mm2) has several improvements to
the rfkill class that I need for thinkpad-acpi, plus two fluff and
documentation fixes.

I'd appreciate comments, and if the patches are acceptable, that they are
sent to mainline early during the 2.6.26 merge window.  That way, I could
try for a thinkpad-acpi rfkill submission for 2.6.26 as well.

The thinkpad-acpi work that needs these patches is ready, and can be
looked at on the thinkpad-acpi git tree (devel branch):
http://repo.or.cz/w/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git

Note: new thinkpads have a read-only "type any" radio switch, plus
read-write WWAN and Bluetooth radio switches.   The embedded WLAN cards
have WLAN read-write switches (that should be handled by the ipw* and iwl*
drivers).  Very old thinkpads had ACPI-based WLAN radio switches, but
thinkpad-acpi does not support those.

Shortlog:
Henrique de Moraes Holschuh (8):
      rfkill: clarify meaning of rfkill states
      rfkill: fix minor typo in kernel doc
      rfkill: handle KEY_RADIO and SW_RADIO events
      rfkill: add read-write rfkill switch support
      rfkill: add read-only rfkill switch support
      rfkill: add the WWAN radio type
      rfkill: add an "any radio" switch type and functionality
      rfkill: add parameter to disable radios by default

Diffstat:
 include/linux/rfkill.h    |   18 ++++--
 net/rfkill/rfkill-input.c |   71 +++++++++++++++++++++++-
 net/rfkill/rfkill.c       |  134 ++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 207 insertions(+), 16 deletions(-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
