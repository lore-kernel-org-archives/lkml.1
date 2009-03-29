Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZC2JAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZC2JAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 05:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZC2JAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 05:00:21 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:33747 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZC2JAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 05:00:20 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net
Subject: Re: soft lockup apparently in ath5k_hw_update_mib_counters (or ioread32?) with 2.6.29
References: <87tz5ckfye.fsf@burly.wgtn.ondioline.org>
	<49CF316D.6040903@gmail.com>
Date: Sun, 29 Mar 2009 22:00:18 +1300
In-Reply-To: <49CF316D.6040903@gmail.com> (Jiri Slaby's message of "Sun, 29
	Mar 2009 10:29:33 +0200")
Message-ID: <87prg0k8kd.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:

> On 03/29/2009 08:20 AM, Paul Collins wrote:
>> After about two days of uptime with 2.6.29 I got this:
>> 
>> BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]
>> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables vfat fat usb_storage sch_sfq i915 drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect btusb rfcomm hidp l2cap bluetooth tun cpufreq_stats rpcsec_gss_krb5 nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc fuse cbc aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod fbcon font bitblit softcursor fb kvm_intel kvm acpi_cpufreq firewire_sbp2 loop snd_hda_intel snd_pcm arc4 snd_seq_midi snd_rawmidi ecb snd_seq_midi_event snd_seq snd_timer ath5k snd_seq_device snd mac80211 soundcore firewire_ohci firewire_core thermal snd_page_alloc cfg80211 i2c_i801 crc_itu_t button processor evdev
>> CPU 0:
>> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables vfat fat usb_storage sch_sfq i915 drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect btusb rfcomm hidp l2cap bluetooth tun cpufreq_stats rpcsec_gss_krb5 nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc fuse cbc aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod fbcon font bitblit softcursor fb kvm_intel kvm acpi_cpufreq firewire_sbp2 loop snd_hda_intel snd_pcm arc4 snd_seq_midi snd_rawmidi ecb snd_seq_midi_event snd_seq snd_timer ath5k snd_seq_device snd mac80211 soundcore firewire_ohci firewire_core thermal snd_page_alloc cfg80211 i2c_i801 crc_itu_t button processor evdev
>> Pid: 0, comm: swapper Not tainted 2.6.29-00003-g0be8685 #163 Macmini2,1
>> RIP: 0010:[<ffffffff803950f0>]  [<ffffffff803950f0>] ioread32+0xf/0x32
>
> Huh. I see no reason for this to happen. I suppose this is a regression,
> which kernel worked?

I had a previous instance of the problem with v2.6.29-rc8 after about
six days of uptime.  The kernel before that was 2.6.29-rc7ish, ran OK
for a couple of days.  But since I don't know how to reproduce it
reliably it's hard to say which kernel is truly good.

> There is nothing like "too many interrupts, giving up for now" in dmesg,
> right?

No, no messages like that.  I do however get timing-related errors at
about the time the soft lockup detector indicates the problem began.

With 2.6.29 I got

        Mar 29 18:45:48 burly kernel: Clocksource tsc unstable (delta = 532189008 ns)
        Mar 29 18:46:11 burly kernel: wlan0: No ProbeResp from current AP 00:1a:70:ee:7c:d6 - assume out of range
        Mar 29 18:46:34 burly kernel: BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]

and with 2.6.29-rc8 I got

        Mar 20 21:19:59 burly kernel: CE: hpet increasing min_delta_ns to 22500 nsec
        Mar 20 21:21:02 burly kernel: BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]

but maybe these just symptoms.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
