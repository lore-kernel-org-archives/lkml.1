Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYDBMTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYDBMTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756143AbYDBMTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:19:32 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:24743 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbYDBMTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:19:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nAIH77j6F0XEtlan5gPnUsOXABRgm7oDA2NP1vPAzJL0o22qzwTmCZSajsrvSzRwv9LGJlb4rsouWq+6M0TM2+0NvUNhOmZWq57eYFOqt/hN0DQsyxf/SwM4U+I2K+keqb7SdqXDBDmBU3gOb2ulPT4F5fc8dBdpHY/LyEXysHM=
Message-ID: <a44ae5cd0804020519o26603c1etfd166855e550f5b4@mail.gmail.com>
Date: Wed, 2 Apr 2008 08:19:29 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, matt.jared@intel.com,
       andy.kopp@intel.com, dan.d.kogan@intel.com,
       "Jaroslav Kysela" <perex@perex.cz>,
       "Abramo Bagnara" <abramo@alsa-project.org>
Subject: 2.6.25-rc8-mm1 -- BUG: bad unlock balance detected!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[   48.765906] [ BUG: bad unlock balance detected! ]
[   48.765912] -------------------------------------
[   48.765918] pulseaudio/4277 is trying to release lock
(&codec->spdif_mutex) at:
[   48.765930] [<c03031b7>] mutex_unlock+0x8/0xa
[   48.765945] but there are no more locks to release!
[   48.765950]
[   48.765952] other info that might help us debug this:
[   48.765959] 2 locks held by pulseaudio/4277:
[   48.765965]  #0:  (&pcm->open_mutex){--..}, at: [<f89f134b>]
snd_pcm_open+0xc1/0x1ba [snd_pcm]
[   48.766003]  #1:  (&chip->open_mutex){--..}, at: [<f8b4f13d>]
azx_pcm_open+0x36/0x184 [snd_hda_intel]
[   48.766057]
[   48.766059] stack backtrace:
[   48.766066] Pid: 4277, comm: pulseaudio Not tainted 2.6.25-rc8-mm1 #12
[   48.766086]  [<c013afc6>] print_unlock_inbalance_bug+0xce/0xd8
[   48.766107]  [<c0109e1c>] ? save_stack_trace+0x1d/0x3b
[   48.766130]  [<c012f54e>] ? __kernel_text_address+0x1b/0x27
[   48.766146]  [<c0104533>] ? dump_trace+0xcd/0xd9
[   48.766160]  [<c0109d9e>] ? save_stack_address+0x0/0x2c
[   48.766176]  [<c013b80a>] ? find_usage_backwards+0xa4/0xc3
[   48.766193]  [<c013cfb5>] lock_release_non_nested+0x84/0x120
[   48.766209]  [<c03031b7>] ? mutex_unlock+0x8/0xa
[   48.766222]  [<c013d1bb>] lock_release+0x16a/0x199
[   48.766238]  [<c0303137>] __mutex_unlock_slowpath+0xa9/0x121
[   48.766252]  [<c03031b7>] mutex_unlock+0x8/0xa
[   48.766263]  [<f8b4ffd8>] snd_hda_multi_out_analog_open+0xd3/0xef
[snd_hda_intel]
[   48.766321]  [<f8b5d2f4>] stac92xx_playback_pcm_open+0x14/0x19
[snd_hda_intel]
[   48.766385]  [<f8b4f22d>] azx_pcm_open+0x126/0x184 [snd_hda_intel]
[   48.766446]  [<f89f1239>] snd_pcm_open_substream+0x46/0x97 [snd_pcm]
[   48.766476]  [<f89f135c>] snd_pcm_open+0xd2/0x1ba [snd_pcm]
[   48.766505]  [<c011a12b>] ? default_wake_function+0x0/0xd
[   48.766522]  [<f8950079>] ? snd_lookup_minor_data+0x3f/0x46 [snd]
[   48.766553]  [<f89f16b1>] snd_pcm_playback_open+0x23/0x26 [snd_pcm]
[   48.766581]  [<f8950458>] snd_open+0x101/0x190 [snd]
[   48.766611]  [<c017fc27>] chrdev_open+0x156/0x172
[   48.766628]  [<c017c39a>] __dentry_open+0x13a/0x229
[   48.766646]  [<c017c4a8>] nameidata_to_filp+0x1f/0x33
[   48.766658]  [<c017fad1>] ? chrdev_open+0x0/0x172
[   48.766673]  [<c0186b3f>] do_filp_open+0x34a/0x69a
[   48.766690]  [<c0178ca4>] ? __slab_alloc+0xbe/0x547
[   48.766709]  [<c017c151>] ? get_unused_fd_flags+0xbd/0xc7
[   48.766730]  [<c017c151>] ? get_unused_fd_flags+0xbd/0xc7
[   48.766748]  [<c017c19b>] do_sys_open+0x40/0xb6
[   48.766764]  [<c017c23d>] sys_open+0x16/0x18
[   48.766776]  [<c0103444>] sysenter_past_esp+0x6d/0xc5
