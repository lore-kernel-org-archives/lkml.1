Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYAEOek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYAEOek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 09:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbYAEOed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 09:34:33 -0500
Received: from aun.it.uu.se ([130.238.12.36]:33824 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbYAEOec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:34:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18303.38257.850625.70108@harpo.it.uu.se>
Date: Sat, 5 Jan 2008 15:34:25 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Alexander Shaduri <ashaduri@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: BUG: unable to handle kernel paging request at virtual address
In-Reply-To: <20080105173601.75370546@linux.localdomain>
References: <20080104213812.20268840@linux.localdomain>
	<20080105091012.GG27894@ZenIV.linux.org.uk>
	<20080105173601.75370546@linux.localdomain>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Shaduri writes:
 > On Sat, 5 Jan 2008 09:10:12 +0000
 > Al Viro <viro@ZenIV.linux.org.uk> wrote:
 > 
 > > and we have q->page == 0x48464443.  Seeing how we assign that sucker, that
 > > smells like we've got a page on quicklist with {0x43, 0x44, 0x46, 0x48}
 > > in its first 4 bytes.  Instead of having address of the next page stored
 > > in there...
 > > 
 > > Do other oopsen of the same kind give the same value?
 > 
 > I've got another oops here with a different value. This time a bttv message
 > preceded it. Note that the oops happened shortly *after* I stopped capturing
 > (watching the tv through mplayer).
 > 
 > Output of dmesg:
 > 
 > bttv0: OCERR @ 375e2014,bits: HSYNC OFLOW FDSR OCERR*
 > (two pages of the same message here)
 > 
 > bttv0: OCERR @ 375e2014,bits: HSYNC OFLOW FDSR OCERR*
 > bttv0: OCERR @ 375e2014,bits: HSYNC OFLOW FBUS FDSR OCERR*
 > BUG: unable to handle kernel paging request at virtual address 23232323
 >  printing eip:
 > c011d6f8
 > *pde = 00000000
 > Oops: 0000 [#1]
 > PREEMPT SMP
 > Modules linked in: ppp_generic slhc iptable_filter ip_tables ip6table_filter ip6_tables x_tables ipv6 cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave powernow_k8 freq_table snd_pcm_oss snd_mixer_oss snd_seq_midi snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_event snd_seq_midi_emul snd_seq capability commoncap fuse nls_koi8_r nls_cp866 loop dm_mod binfmt_misc uhci_hcd it87 hwmon_vid eeprom nvidia(P) tuner tvaudio snd_emu10k1 bttv snd_rawmidi snd_ac97_codec video_buf firmware_class ir_common ac97_bus snd_pcm snd_seq_device compat_ioctl32 i2c_algo_bit snd_timer snd_page_alloc emu10k1_gp snd_util_mem btcx_risc tveeprom videodev gameport ohci1394 ieee1394 ide_cd snd_hwdep snd v4l2_common v4l1_compat agpgart soundcore i2c_nforce2 thermal button rtc_cmos rtc_core rtc_lib forcedeth k8temp i2c_core hwmon cdrom sg ohci_hcd ehci_hcd usbcore edd fan processor pata_amd
 > CPU:    0
 > EIP:    0060:[<c011d6f8>]    Tainted: P        VLI

This kernel is tainted by the nvidia module...
