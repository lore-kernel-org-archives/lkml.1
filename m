Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYKJRSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYKJRSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 12:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYKJRSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 12:18:10 -0500
Received: from styx.suse.cz ([82.119.242.94]:43082 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753859AbYKJRSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 12:18:08 -0500
Date: Mon, 10 Nov 2008 18:18:05 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: BUG: scheduling while atomic: iwl3945/0/3680/0x00000002 during
	resume from suspend
Message-ID: <20081110171805.GA5455@dhcp35.suse.cz>
References: <20081109141412.GA5858@dhcp35.suse.cz> <49172112.60508@gmail.com> <1226279540.2604.277.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <1226279540.2604.277.camel@debian.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 10-11-08 09:12:20, Zhu Yi wrote:
> On Mon, 2008-11-10 at 01:42 +0800, Jiri Slaby wrote:
> > I think the same as:
> > http://marc.info/?l=linux-wireless&m=122254514501379&w=2
> 
> Yup. Try this fix.
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=605b6cd038c5002f8dcbd3695aa934a130257af4

I have tried this patch (attached to be sure that we are talking about
the same one), but the problem is still here:

BUG: scheduling while atomic: iwl3945/0/3677/0x00000002
Modules linked in: aes_i586 aes_generic i915 drm fuse tun coretemp hwmon arc4 ecb snd_hda_intel snd_pcm snd_seq iwl3945 snd_timer mac80211 led_class snd_seq_device snd cfg80211 snd_page_alloc rtc_cmos rtc_core rtc_lib fujitsu_laptop backlight sky2
Pid: 3677, comm: iwl3945/0 Not tainted 2.6.28-rc3 #1
Call Trace:
 [<c0121b09>] __schedule_bug+0x48/0x4d
 [<c03f1747>] schedule+0xa1/0x8b4
 [<c012260d>] ? enqueue_task_fair+0x2fd/0x305
 [<c012200d>] ? check_preempt_wakeup+0x110/0x13e
 [<c03f38ca>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c0123cb4>] ? try_to_wake_up+0x24a/0x255
 [<c03f20d5>] schedule_timeout+0x17/0xbc
 [<c011bdac>] ? __wake_up_common+0x35/0x5b
 [<c03f38ca>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c03f159d>] wait_for_common+0xa8/0xfe
 [<c0123cbf>] ? default_wake_function+0x0/0xd
 [<c03f1665>] wait_for_completion+0x12/0x14
 [<c01363af>] synchronize_rcu+0x2d/0x33
 [<c01362c9>] ? wakeme_after_rcu+0x0/0xd
 [<f877a746>] __ieee80211_key_todo+0xe/0x1c1 [mac80211]
 [<c03f38ca>] ? _spin_unlock_irqrestore+0x11/0x25
 [<c03f371d>] ? _spin_lock_irqsave+0x14/0x2e
 [<c03f38ca>] ? _spin_unlock_irqrestore+0x11/0x25
 [<f876b921>] ? __sta_info_unlink+0xbf/0x163 [mac80211]
 [<f877a9d7>] ieee80211_key_todo+0x12/0x1e [mac80211]
 [<f876bf47>] sta_info_destroy+0x1e/0x9b [mac80211]
 [<f876b9f1>] ? sta_info_unlink+0x2c/0x31 [mac80211]
 [<f87703f1>] ieee80211_set_disassoc+0x1a2/0x1aa [mac80211]
 [<f87704d8>] ieee80211_sta_req_auth+0x3f/0x61 [mac80211]
 [<f8770533>] ieee80211_notify_mac+0x39/0x65 [mac80211]
 [<f88dac90>] iwl3945_bg_alive_start+0x545/0x5bc [iwl3945]
 [<c013500c>] run_workqueue+0x79/0x101
 [<f88da74b>] ? iwl3945_bg_alive_start+0x0/0x5bc [iwl3945]
 [<c013514b>] worker_thread+0xb7/0xc3
 [<c0138003>] ? autoremove_wake_function+0x0/0x33
 [<c0135094>] ? worker_thread+0x0/0xc3
 [<c0137ced>] kthread+0x3b/0x61
 [<c0137cb2>] ? kthread+0x0/0x61
 [<c010480b>] kernel_thread_helper+0x7/0x10

> 
> Thanks,
> -yi
> 

-- 
Michal Hocko
L3 team 
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic

--7JfCtLOvnd9MIVvH
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="wireless-testing.git-605b6cd038c5002f8dcbd3695aa934a130257af4.patch"

From: Zhu, Yi <yi.zhu@intel.com>
Date: Tue, 4 Nov 2008 20:21:36 +0000 (-0800)
Subject: iwl3945: fix deadlock on suspend
X-Git-Tag: master-2008-11-07~185
X-Git-Url: http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Flinville%2Fwireless-testing.git;a=commitdiff_plain;h=605b6cd038c5002f8dcbd3695aa934a130257af4

iwl3945: fix deadlock on suspend

This patch fixes iwl3945 deadlock during suspend by moving notify_mac out
of iwl3945 mutex. This is a portion of the same fix for iwlwifi by Tomas.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 81dfcb8..285b53e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -5768,7 +5768,6 @@ static void iwl3945_alive_start(struct iwl3945_priv *priv)
 	if (priv->error_recovering)
 		iwl3945_error_recovery(priv);
 
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 	return;
 
  restart:
@@ -6013,6 +6012,7 @@ static void iwl3945_bg_alive_start(struct work_struct *data)
 	mutex_lock(&priv->mutex);
 	iwl3945_alive_start(priv);
 	mutex_unlock(&priv->mutex);
+	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
 }
 
 static void iwl3945_bg_rf_kill(struct work_struct *work)

--7JfCtLOvnd9MIVvH--
