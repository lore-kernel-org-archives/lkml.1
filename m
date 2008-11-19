Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYKSUpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYKSUpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYKSUpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:45:04 -0500
Received: from ox1.aei.mpg.de ([194.94.224.6]:58024 "EHLO ox1.aei.mpg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYKSUpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:45:01 -0500
Date: Wed, 19 Nov 2008 21:45:24 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: iwlagn driver segfault in 2.6.28-rc3
Message-ID: <20081119204524.GA30179@localhost.aei.mpg.de>
References: <20081111143410.GA4401@ics.muni.cz> <1226560041.1115.945.camel@rc-desk> <20081116120621.GA3937@localhost.aei.mpg.de> <1ba2fa240811160429ld8cc080s7e023b0398eeda08@mail.gmail.com> <20081116125148.GA16746@localhost.aei.mpg.de> <1ba2fa240811161554r45d98ae7h3a37ae78c332a4dd@mail.gmail.com> <20081117003941.GA21367@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117003941.GA21367@localhost.aei.mpg.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 17.Nov'08 at  1:39:41 +0100, Carlos R. Mafra wrote:
> On Mon 17.Nov'08 at  1:54:16 +0200, Tomas Winkler wrote:
> [...]
> > Can you please try this one (might be white space broken, just pasted in)
> 
> Sure, I've already applied it by hand and will start testing it right away.
> 
> But it will take many days until I can report back about it, because
> this oops happened only two times in one month or so.

Ok, the WARN() in your patch from Sunday (quoted below) appeared in my logs.
I've just noticed now (but it is the 3rd or 4th time already in dmesg, that
is why it appears "Tainted")

I don't if the situation leading to the WARN() in your patch is the same
one which used to kill my wireless connection before (with the oops
in iwl_eeprom_query16 that started this thread), but the fact is
that my wifi is still working.

Here is the log: 

[ I have the full dmesg from sunday up to now, with
lots of s2ram cycles in the middle. I can send it if needed ]


------------[ cut here ]------------
WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:738 iwl_remove_dynamic_key+0x212/0x220()
Removing wrong key 1 0x410a
Modules linked in: xt_comment xt_policy xt_tcpmss xt_pkttype xt_owner xt_NFQUEUE xt_NFLOG xt_multiport xt_MARK xt_mark xt_mac xt_limit xt_length xt_ipra                     nge xt_hashlimit xt_dscp xt_dccp xt_CLASSIFY snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss nvram uvcvideo snd_hda_inte                     l snd_pcm compat_ioctl32 ohci1394 i2c_i801 videodev snd_timer ieee1394 v4l1_compat iwlagn snd_page_alloc evdev sg sky2 snd_hwdep sr_mod ata_piix ahci li                     bata sd_mod scsi_mod uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded: scsi_wait_scan]
Pid: 9, comm: events/0 Tainted: G        W  2.6.28-rc5-tomas-iwlagn-00019-ge14c8bf-dirty #21
Call Trace:
 [<ffffffff80239947>] warn_slowpath+0xb7/0xe0
 [<ffffffff80213420>] ? nommu_map_single+0x0/0x70
 [<ffffffff80213420>] ? nommu_map_single+0x0/0x70
 [<ffffffff803df221>] ? iwl_enqueue_hcmd+0x271/0x430
 [<ffffffff803d9edf>] ? iwl_send_cmd+0xf/0x20
 [<ffffffff803e1624>] ? iwl_send_add_sta+0x84/0x180
 [<ffffffff803e2c42>] iwl_remove_dynamic_key+0x212/0x220
 [<ffffffffa00ed2ba>] iwl4965_mac_set_key+0x27a/0x410 [iwlagn]
 [<ffffffff804be29d>] ieee80211_key_disable_hw_accel+0x9d/0xf0
 [<ffffffff8030e94b>] ? crypto_free_tfm+0x5b/0x70
 [<ffffffff804be470>] __ieee80211_key_todo+0x180/0x1f0
 [<ffffffff804be640>] ? key_todo+0x0/0x10
 [<ffffffff804be62e>] ieee80211_key_todo+0xe/0x20
 [<ffffffff804be649>] key_todo+0x9/0x10
 [<ffffffff8024afdb>] run_workqueue+0xbb/0x150
 [<ffffffff8024bc63>] worker_thread+0xa3/0x110
 [<ffffffff8024eff0>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8024bbc0>] ? worker_thread+0x0/0x110
 [<ffffffff8024eb1d>] kthread+0x4d/0x80
 [<ffffffff8020d0e9>] child_rip+0xa/0x11
 [<ffffffff8024ead0>] ? kthread+0x0/0x80
 [<ffffffff8020d0df>] ? child_rip+0x0/0x11
---[ end trace 504c57ff44d53cd9 ]---




> > diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c
> > b/drivers/net/wireless/iwlwifi/iwl-sta.c
> > index 61797f3..d848c63 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-sta.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
> > @@ -734,6 +734,12 @@ int iwl_remove_dynamic_key(struct iwl_priv *priv,
> >                 return 0;
> >         }
> > 
> > +       if (WARN(priv->stations[sta_id].sta.key.key_offset ==
> > WEP_INVALID_OFFSET,
> > +               "Removing wrong key %d 0x%x\n", keyconf->keyidx, key_flags)) {
> > +               spin_unlock_irqrestore(&priv->sta_lock, flags);
> > +               return 0;
> > +       }
> > +
> >         if (!test_and_clear_bit(priv->stations[sta_id].sta.key.key_offset,
> >                 &priv->ucode_key_table))
> >                 IWL_ERROR("index %d not used in uCode key table.\n",
> > 
> > Thanks
> > Tomas
> > 

