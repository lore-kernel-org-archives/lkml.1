Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYKJJuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYKJJuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 04:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbYKJJuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 04:50:44 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:44926 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbYKJJum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 04:50:42 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: BUG: scheduling while atomic: iwl3945/0/3680/0x00000002 during resume from suspend
Date: Mon, 10 Nov 2008 10:49:01 +0100
User-Agent: KMail/1.9.9
Cc: Jiri Slaby <jirislaby@gmail.com>, Michal Hocko <mhocko@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
References: <20081109141412.GA5858@dhcp35.suse.cz> <49172112.60508@gmail.com> <1226279540.2604.277.camel@debian.sh.intel.com>
In-Reply-To: <1226279540.2604.277.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811101049.01759.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 10. November 2008 schrieb Zhu Yi:
> On Mon, 2008-11-10 at 01:42 +0800, Jiri Slaby wrote:
> > I think the same as:
> > http://marc.info/?l=linux-wireless&m=122254514501379&w=2
> 
> Yup. Try this fix.
> 
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=605b6cd038c5002f8dcbd3695aa934a130257af4

I got a similar one on
03:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or AGN 
[Kedron] Network Connection (rev 61)

with a pretty decent git: 2.6.28-rc3-00255-g6209344.
This version contains the fix for iwlwifi, but I still see this bug.

[ 2267.565839] Registered led device: iwl-phy0:radio
[ 2267.565877] Registered led device: iwl-phy0:assoc
[ 2267.565911] Registered led device: iwl-phy0:RX
[ 2267.565947] Registered led device: iwl-phy0:TX
[ 2267.566039] BUG: scheduling while atomic: iwlagn/0/1385/0x00000002
[ 2267.566043] Modules linked in: psmouse iwlagn ehci_hcd uhci_hcd
[ 2267.566056] Pid: 1385, comm: iwlagn/0 Not tainted 2.6.28-rc3-00255-g6209344 
#25
[ 2267.566060] Call Trace:
[ 2267.566072]  [<c0523d1c>] ? printk+0x18/0x1a
[ 2267.566081]  [<c0140051>] __schedule_bug+0x61/0x70
[ 2267.566088]  [<c0524197>] schedule+0x2b7/0x6d0
[ 2267.566097]  [<c01621ab>] ? getnstimeofday+0x4b/0xf0
[ 2267.566103]  [<c0524a3d>] schedule_timeout+0xad/0xf0
[ 2267.566109]  [<c0132783>] ? lapic_next_event+0x13/0x20
[ 2267.566117]  [<c0165878>] ? clockevents_program_event+0x98/0x150
[ 2267.566123]  [<c01383f8>] ? default_spin_lock_flags+0x8/0x10
[ 2267.566130]  [<c052481a>] wait_for_common+0x8a/0x140
[ 2267.566137]  [<c01411c0>] ? default_wake_function+0x0/0x10
[ 2267.566144]  [<c0524962>] wait_for_completion+0x12/0x20
[ 2267.566150]  [<c0159bcd>] synchronize_rcu+0x2d/0x40
[ 2267.566156]  [<c0159ad0>] ? wakeme_after_rcu+0x0/0x10
[ 2267.566164]  [<c050f60e>] __ieee80211_key_todo+0xe/0x230
[ 2267.566170]  [<c01383f8>] ? default_spin_lock_flags+0x8/0x10
[ 2267.566177]  [<c04fd70a>] ? __sta_info_unlink+0xca/0x190
[ 2267.566182]  [<c01383f8>] ? default_spin_lock_flags+0x8/0x10
[ 2267.566189]  [<c050f942>] ieee80211_key_todo+0x12/0x20
[ 2267.566195]  [<c04fde21>] sta_info_destroy+0x21/0xc0
[ 2267.566201]  [<c0504363>] ieee80211_set_disassoc+0x183/0x210
[ 2267.566209]  [<c0504563>] ieee80211_sta_req_auth+0x83/0x90
[ 2267.566215]  [<c0506591>] ieee80211_notify_mac+0x51/0x80
[ 2267.566229]  [<f83b492a>] iwl_bg_alive_start+0x7a/0x2c0 [iwlagn]
[ 2267.566241]  [<f83b9741>] ? iwl4965_init_alive_start+0x1c1/0x1d0 [iwlagn]
[ 2267.566250]  [<c0158421>] run_workqueue+0x81/0x150
[ 2267.566260]  [<f83b48b0>] ? iwl_bg_alive_start+0x0/0x2c0 [iwlagn]
[ 2267.566277]  [<c01586a8>] worker_thread+0x88/0xf0
[ 2267.566283]  [<c015c0f0>] ? autoremove_wake_function+0x0/0x40
[ 2267.566290]  [<c0158620>] ? worker_thread+0x0/0xf0
[ 2267.566295]  [<c015bdcc>] kthread+0x3c/0x70
[ 2267.566300]  [<c015bd90>] ? kthread+0x0/0x70
[ 2267.566307]  [<c011fc23>] kernel_thread_helper+0x7/0x14
