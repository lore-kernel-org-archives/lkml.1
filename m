Return-Path: <linux-kernel-owner+w=401wt.eu-S933613AbYF3WRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613AbYF3WRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 18:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763412AbYF3WRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 18:17:20 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3623 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762094AbYF3WRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 18:17:17 -0400
Date: Mon, 30 Jun 2008 17:56:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-next-2.6 2008-06-30
Message-ID: <20080630215651.GA666@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

Here is another slew of updates for 2.6.27.  The bulk of this batch is
for iwlwifi, with some mac80211 and other bits thrown-in.

Let me know if there are problems!

Thanks,

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-next-2.6/
---

The following changes since commit 28f49d8fec19833672a6a813bfde0068fee50bc9:
  David S. Miller (1):
        Merge branch 'master' of master.kernel.org:/.../linville/wireless-next-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git master

Abhijeet Kolekar (2):
      iwlwifi : Patch adds rfkill subsystem for 3945
      iwlwifi: Remove unnecessary code

Adel Gadllah (3):
      iwlwifi: fix rfkill deps and remove input device usage
      b43/b43legacy: use RFKILL_STATE_UNBLOCKED instead of RFKILL_STATE_ON
      b43/b43legacy: add RFKILL_STATE_HARD_BLOCKED support

Adrian Bunk (1):
      build algorithms into the mac80211 module

Assaf Krauss (2):
      mac80211: add beacon timestamp to beacon template in IBSS
      iwlwifi: adjust TSF in IBSS

Emmanuel Grumbach (12):
      mac80211: add last beacon time in scan list
      iwlwifi: better station table maintenance
      iwlwifi: add REPLY_TX_POWER_DBM_CMD to get_cmd_string
      iwlwifi: send ADD_STA before RXON with assoc bit
      iwlwifi: move RX stats to core, and move temperature to handler
      iwlwifi: don't send REPLY_REMOVE_ALL_STA upon exit
      iwlwifi: move RX handlers to iwl-rx.c
      iwlwifi: remove useless network and duplicate checking
      iwlwifi: setup compressed BA handler
      iwlwifi: don't bring up interface if RF-kill avoids radio
      iwlwifi: blocking mac_start until uCode is complete
      iwlwifi: clean up HW RF-kill state machine and restarts

Ester Kummer (1):
      mac80211: removing duplicated parsing of information elements

Gregory Greenman (1):
      iwlwifi: configure uCode to use open loop tx power algorithm

Johannes Berg (3):
      mac80211: get rid of function pointers in TX path
      mac80211: get rid of function pointers in RX path
      mac80211: rework debug settings and make debugging safer

John W. Linville (1):
      iwl-rfkill.c: correct 'recieved' typo

Larry.Finger@lwfinger.net (1):
      p54: Add quality output to iwlist and iwconfig

Mohamed Abbas (1):
      iwlwifi: keep the STATUS_EXIT_PENDING flag till the end of down flow

Pavel Roskin (3):
      hostap: don't skip any headers in hostap_80211_header_parse()
      hostap: add radiotap support in monitor mode
      hostap: use radiotap headers by default

Rick Farrington (2):
      iwlwifi: fix incorrect 5GHz rates reported in monitor mode
      iwlwifi: fix incorrect monitor mode operation

Ron Rindjunsky (6):
      iwlwifi: use iwl_is_associated when possible
      iwlwifi: move rx aggregation functions to iwl-rx.c
      iwlwifi: remove obsolete lq_ready use
      iwlwifi: unite common settings of HW params
      iwlwifi: control 11n capabilities through module param
      iwlwifi: eliminate iwl4965_mac_get_tsf

Stefanik Gábor (1):
      iwlwifi: enable packet injection for iwl3945

Tomas Winkler (5):
      mac80211: add spectrum capabilities
      mac80211: fix warning: unused variable invoke_tx_handlers
      iwlwifi: Add eeprom version to the version file in sysfs
      iwlwifi: fix IBSS association flow
      iwlwifi: fix 4965 uCode load

Yi Zhu (1):
      mac80211: add MAC80211_VERBOSE_SPECT_MGMT_DEBUG Kconfig option

Zhu Yi (3):
      iwlwifi: drop skb silently for Tx request in monitor mode
      iwlwifi: fix iwl4965 temperature callback calibration issue
      iwl3945: remove RFKILL_STATE_HARD_BLOCKED warnings

 drivers/net/wireless/b43/rfkill.c             |   20 +-
 drivers/net/wireless/b43legacy/rfkill.c       |   20 +-
 drivers/net/wireless/hostap/hostap_80211_rx.c |   21 +
 drivers/net/wireless/hostap/hostap_hw.c       |    1 +
 drivers/net/wireless/hostap/hostap_ioctl.c    |    5 +-
 drivers/net/wireless/hostap/hostap_main.c     |   20 +-
 drivers/net/wireless/hostap/hostap_wlan.h     |   14 +-
 drivers/net/wireless/iwlwifi/Kconfig          |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h       |   25 +
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c    |   22 +-
 drivers/net/wireless/iwlwifi/iwl-4965-rs.h    |    8 -
 drivers/net/wireless/iwlwifi/iwl-4965.c       |  995 +------------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c       |   27 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-calib.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h   |   12 +-
 drivers/net/wireless/iwlwifi/iwl-core.c       |   63 ++-
 drivers/net/wireless/iwlwifi/iwl-core.h       |   17 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h        |   20 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-rfkill.c     |   41 +-
 drivers/net/wireless/iwlwifi/iwl-rfkill.h     |    2 -
 drivers/net/wireless/iwlwifi/iwl-rx.c         |  860 +++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-sta.c        |  149 +++--
 drivers/net/wireless/iwlwifi/iwl-sta.h        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c         |  143 ++++
 drivers/net/wireless/iwlwifi/iwl3945-base.c   |  245 +++++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c   |  442 ++++--------
 drivers/net/wireless/p54/p54common.c          |    1 +
 include/net/mac80211.h                        |    5 +
 net/mac80211/Kconfig                          |  162 +++--
 net/mac80211/Makefile                         |   18 +-
 net/mac80211/ieee80211_i.h                    |    6 +
 net/mac80211/iface.c                          |    6 +-
 net/mac80211/main.c                           |   35 +-
 net/mac80211/mesh_pathtbl.c                   |    1 -
 net/mac80211/mlme.c                           |  426 +++++------
 net/mac80211/rate.h                           |    4 +-
 net/mac80211/rc80211_pid_algo.c               |   10 -
 net/mac80211/rx.c                             |  203 ++----
 net/mac80211/sta_info.c                       |    2 +
 net/mac80211/tx.c                             |   77 +-
 net/mac80211/wep.c                            |   13 +-
 net/mac80211/wme.c                            |    1 -
 net/mac80211/wpa.c                            |   28 +-
 46 files changed, 2053 insertions(+), 2135 deletions(-)

Omnibus patch available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-next-2.6-2008-06-30.patch.bz2
-- 
John W. Linville
linville@tuxdriver.com
