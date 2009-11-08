Return-Path: <linux-kernel-owner+w=401wt.eu-S1751571AbZKHGj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbZKHGj6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 01:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbZKHGj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 01:39:58 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:39736 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZKHGj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 01:39:57 -0500
Date: Sun, 8 Nov 2009 07:40:00 +0100
To: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Warning in 2.6.32-rc6
Message-ID: <20091108064000.GD13313@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here is a warning I consistently get with a specific access point while
trying to connect the first time after reboot. Later connections work
out fine.


[  307.513081] Registered led device: iwl-phy0::radio
[  307.513515] Registered led device: iwl-phy0::assoc
[  307.513892] Registered led device: iwl-phy0::RX
[  307.514259] Registered led device: iwl-phy0::TX
[  307.582422] wlan0: direct probe to AP 00:0d:0b:04:5d:8d (try 1)
[  307.584616] wlan0: direct probe responded
[  307.584624] wlan0: authenticate with AP 00:0d:0b:04:5d:8d (try 1)
[  307.586484] wlan0: authenticated
[  307.586523] wlan0: associate with AP 00:0d:0b:04:5d:8d (try 1)
[  307.587343] wlan0: deauthenticating from 00:0d:0b:04:5d:8d by local choice (reason=3)
[  307.587434] wlan0: direct probe to AP 00:0d:0b:04:5d:8d (try 1)
[  307.588623] wlan0: RX AssocResp from 00:0d:0b:04:5d:8d (capab=0x401 status=0 aid=3)
[  307.588630] wlan0: associated
[  307.589872] ------------[ cut here ]------------
[  307.589909] WARNING: at net/wireless/mlme.c:97 cfg80211_send_rx_assoc+0x1a3/0x1a8 [cfg80211]()
[  307.589915] Hardware name: VGN-Z11VN_B
[  307.589919] Modules linked in: sco rfcomm bnep l2cap crc16 vboxnetadp vboxnetflt hso binfmt_misc dm_crypt dm_mod btrfs zlib_deflate crc32c libcrc32c vfat fat fuse vboxdrv loop uinput snd_hda_codec_realtek arc4 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq iwlagn snd_timer snd_seq_device btusb iwlcore mac80211 bluetooth firewire_ohci snd cfg80211 joydev sony_laptop rfkill firewire_core crc_itu_t tpm_infineon soundcore snd_page_alloc
[  307.590016] Pid: 1494, comm: phy0 Not tainted 2.6.32-rc6 #6
[  307.590021] Call Trace:
[  307.590040]  [<ffffffffa005d583>] ? cfg80211_send_rx_assoc+0x1a3/0x1a8 [cfg80211]
[  307.590058]  [<ffffffffa005d583>] ? cfg80211_send_rx_assoc+0x1a3/0x1a8 [cfg80211]
[  307.590070]  [<ffffffff8103ae54>] ? warn_slowpath_common+0x77/0xa3
[  307.590088]  [<ffffffffa005d583>] ? cfg80211_send_rx_assoc+0x1a3/0x1a8 [cfg80211]
[  307.590108]  [<ffffffffa00afd62>] ? ieee80211_sta_work+0x4bd/0xe6f [mac80211]
[  307.590117]  [<ffffffff81033feb>] ? finish_task_switch+0x42/0xa5
[  307.590127]  [<ffffffff8102d86b>] ? need_resched+0x1a/0x23
[  307.590137]  [<ffffffff813405b3>] ? thread_return+0x97/0xd4
[  307.590156]  [<ffffffffa00af8a5>] ? ieee80211_sta_work+0x0/0xe6f [mac80211]
[  307.590166]  [<ffffffff8104967a>] ? worker_thread+0x151/0x1ee
[  307.590176]  [<ffffffff8104cd60>] ? autoremove_wake_function+0x0/0x2e
[  307.590184]  [<ffffffff81049529>] ? worker_thread+0x0/0x1ee
[  307.590192]  [<ffffffff8104ca7d>] ? kthread+0x79/0x81
[  307.590202]  [<ffffffff8100bf0a>] ? child_rip+0xa/0x20
[  307.590210]  [<ffffffff8104ca04>] ? kthread+0x0/0x81
[  307.590218]  [<ffffffff8100bf00>] ? child_rip+0x0/0x20
[  307.590223] ---[ end trace f5bccb58d3019056 ]---
[  307.605127] wlan0: deauthenticating from 00:0d:0b:04:5d:8d by local choice (reason=3)


Anything to worry about?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining                                        Associate Professor
JAIST Japan Advanced Institute of Science and Technology   preining@jaist.ac.jp
Vienna University of Technology                               preining@logic.at
Debian Developer (Debian TeX Task Force)                    preining@debian.org
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
NANHORON (n. medical)
A tiny valve concealed in the inner ear which enables a deaf
grandmother to converse quite normally when she feels like it, but
which excludes completely anything that sounds like a request to help
with laying the table.
			--- Douglas Adams, The Meaning of Liff
