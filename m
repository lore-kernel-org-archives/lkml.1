Return-Path: <linux-kernel-owner+w=401wt.eu-S935515AbZLGRFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935515AbZLGRFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:05:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935497AbZLGRFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:05:13 -0500
Received: from mga10.intel.com ([192.55.52.92]:14801 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935445AbZLGRFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:05:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,356,1257148800"; 
   d="scan'208";a="753579493"
Date: Mon, 7 Dec 2009 09:05:17 -0800
From: mark gross <mgross@linux.intel.com>
To: linux-pm <linux-pm@lists.linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, aili@codeaurora.org,
       e1000-devel@lists.sourceforge.net, bruce.w.allan@intel.com,
       linux-wireless@vger.kernel.org, alsa-devel@alsa-project.org,
       tiwai@suse.de
Subject: [PATCH]PM_QOS-to-use-handle-based-requests 0/5
Message-ID: <20091207170517.GA5463@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a 5 patch series against linux-next-20091204 that changes pm_qos
to use a handle based access model for the kernel api.  The string
based model was shown to be slow if pm_qos parameters are updated on hot
code paths.

Most of the design changes where motivated by a patch
aili@codeaurora.org sent me, and I spent some time cleaning up the API.

Also, I couldn't resist myself in renaming the API's a bit given the fact
that the signatures changed enough that I had to touch all the pm_qos
users anyway.  I changed *requirement* to *request* in keeping with the
way PM_QOS really only does best effort.  I've felt "requirement" is too
strong a word for the way it works.

If folks would rather me do the function re-naming in a separate patch
set we can do that too.

diffstat for the series against linux-next-20091204 :
 drivers/acpi/processor_idle.c          |    2
 drivers/cpuidle/governors/ladder.c     |    2
 drivers/cpuidle/governors/menu.c       |    2
 drivers/net/e1000e/netdev.c            |   22 ++-
 drivers/net/igbvf/netdev.c             |    6 -
 drivers/net/wireless/ipw2x00/ipw2100.c |   11 +
 include/linux/netdevice.h              |    4
 include/linux/pm_qos_params.h          |   14 +-
 include/sound/pcm.h                    |    3
 kernel/pm_qos_params.c                 |  188 ++++++++++++++-------------------
 net/mac80211/mlme.c                    |    2
 sound/core/pcm.c                       |    3
 sound/core/pcm_native.c                |   14 +-
 13 files changed, 132 insertions(+), 141 deletions(-)

--mgross

