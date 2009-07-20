Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbZGTSU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbZGTSU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:20:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZGTSUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:20:55 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:59845 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZGTSUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:20:54 -0400
Date: Mon, 20 Jul 2009 23:50:45 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: s2r badness
Message-ID: <20090720182045.GA5537@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1247947383.4872.3.camel@laptop> <alpine.LFD.2.00.0907182223450.11571@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907182223450.11571@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 10:33:08PM +0200, Thomas Gleixner wrote:
> On Sat, 18 Jul 2009, Peter Zijlstra wrote:
> 
> > Hi,
> > 
> > s2r seems to resume again on my latest kernel build (used to be broken
> > for a long-ish while).
> > 
> > However it does generate the blow splats.
> > 
> > [   74.576953] ------------[ cut here ]------------
> > [   74.576953] WARNING: at /usr/src/linux-2.6/kernel/softirq.c:143 local_bh_enable_ip+0x8b/0xc0()
> > [   74.576953] Hardware name: 2242CTO
> > [   74.576953] Modules linked in: cryptd aes_x86_64 aes_generic ecryptfs
> > nfs lockd nfs_acl auth_rpcgss sunrpc binfmt_misc fbcon tileblit font
> > bitblit softcursor bridge stp llc bnep autofs4 acpi_cpufreq joydev btusb
> > coretemp sbp2 snd_hda_codec_conexant pcmcia ecb psmouse serio_raw
> > iTCO_wdt iTCO_vendor_support snd_hda_intel snd_hda_codec snd_pcm_oss
> > pcspkr snd_mixer_oss iwlagn iwlcore snd_pcm mac80211 snd_seq_dummy
> > ricoh_mmc sdhci_pci sdhci snd_seq_oss snd_seq_midi snd_rawmidi
> > snd_seq_midi_event yenta_socket rsrc_nonstatic pcmcia_core cfg80211
> > snd_seq snd_timer snd_seq_device snd soundcore snd_page_alloc i915
> > intel_agp thinkpad_acpi led_class video nvram ohci1394 ieee1394 ehci_hcd
> > uhci_hcd fuse
> > [   74.576953] Pid: 5406, comm: bash Not tainted 2.6.31-rc3-tip #32
> > [   74.576953] Call Trace:
> > [   74.576953]  [<ffffffff8107401b>] ? local_bh_enable_ip+0x8b/0xc0
> > [   74.576953]  [<ffffffff8106c838>] warn_slowpath_common+0x78/0xd0
> > [   74.576953]  [<ffffffff8106c89f>] warn_slowpath_null+0xf/0x20
> > [   74.576953]  [<ffffffff8107401b>] local_bh_enable_ip+0x8b/0xc0
> > [   74.576953]  [<ffffffff814d08d9>] _spin_unlock_bh+0x19/0x20
> > [   74.576953]  [<ffffffff810d2c77>] load_debug_registers+0x67/0x80
> 
> That's the hw breakpoint support stuff which does the spin_unlock_bh
> at a point where interrupts are disabled. So that's a -tip tree issue,
> not mainline.
>

load_debug_registers() uses spin_(un)lock_bh() and not a spin-lock() to
protect itself from flush_thread_hw_breakpoint() [which is invoked in
softIRQ context].

I'd like to recreate this traceback to investigate and fix this. What
steps, when done cause this message to appear?

Thanks,
K.Prasad

