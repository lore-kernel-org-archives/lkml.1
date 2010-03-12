Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab0CLBAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 20:00:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33280 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab0CLBAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 20:00:34 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org, stable@kernel.org
Cc: linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [FYI] cfg80211: HT40 fix for APs with odd country IEs for 2.6.33.y
Date: Thu, 11 Mar 2010 20:00:32 -0500
Message-Id: <1268355632-32348-1-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.6.2.rc1.3.g81d3f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a heads up to distribution maintainers, 2.6.33 has an
issue with disabling HT40 channels if you connect to an AP
that has an odd country IE. Specifically if your AP sends
out country IEs as follows:

[1-1]
[2-2]
[3-3]
[4-4]
[5-5]
[6-6]
[7-7]
[8-8]
[9-9]
[10-10]
[11-11]

instead of like this:

[1-11]

Then HT40 gets disabled. This issue was fixed on 2.6.34 and the fixes
were not propagated to 2.6.33.y as they are not "critical" fixes
per se, but if you do value this as "important" you may want to
fetch them and apply them to your 2.6.33.y kernel tree.

I've backported them and stashed them here:

http://kernel.org/pub/linux/kernel/people/mcgrof/patches/cfg80211/2010-03/reg-fixes-33/01-ht40-odd-country-ie/

John W. Linville (1):
  wireless: fix build breakage when CONFIG_CFG80211_REG_DEBUG not set

Luis R. Rodriguez (7):
  cfg80211: add a regulatory debug print
  cfg80211: add debug print when we drop a bogus country IE
  cfg80211: process the max power on a country IE
  cfg80211: Fix country IE parsing for single channel triplets
  cfg80211: fix 2 GHz subband calculation for country IEs
  cfg80211: Ingore country IEs with a zero set of number of channels
  cfg80211: make regulatory_hint_11d() band specific

 net/wireless/reg.c |  317 +++++++++++++++++++++++++++++++++++++++++++++++-----
 net/wireless/reg.h |   11 ++
 net/wireless/sme.c |    1 +
 3 files changed, 302 insertions(+), 27 deletions(-)

