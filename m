Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbZC2Jhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbZC2Jhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 05:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZC2Jhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 05:37:43 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:55464 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbZC2Jhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 05:37:42 -0400
Message-ID: <49CF4161.6080401@msgid.tls.msk.ru>
Date: Sun, 29 Mar 2009 13:37:37 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Paul Collins <paul@burly.ondioline.org>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: soft lockup apparently in ath5k_hw_update_mib_counters (or ioread32?)
 with 2.6.29
References: <87tz5ckfye.fsf@burly.wgtn.ondioline.org>	<49CF316D.6040903@gmail.com> <87prg0k8kd.fsf@burly.wgtn.ondioline.org>
In-Reply-To: <87prg0k8kd.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Collins wrote:
> Jiri Slaby <jirislaby@gmail.com> writes:
> 
>> On 03/29/2009 08:20 AM, Paul Collins wrote:
>>> After about two days of uptime with 2.6.29 I got this:
>>>
>>> BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]
>>> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables vfat fat usb_storage sch_sfq i915 drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect btusb rfcomm hidp l2cap bluetooth tun cpufreq_stats rpcsec_gss_krb5 nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc fuse cbc aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod fbcon font bitblit softcursor fb kvm_intel kvm acpi_cpufreq firewire_sbp2 loop snd_hda_intel snd_pcm arc4 snd_seq_midi snd_rawmidi ecb snd_seq_midi_event snd_seq snd_timer ath5k snd_seq_device snd mac80211 soundcore firewire_ohci firewire_core thermal snd_page_alloc cfg80211 i2c_i801 crc_itu_t button processor evdev
>>> CPU 0:
>>> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables vfat fat usb_storage sch_sfq i915 drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect btusb rfcomm hidp l2cap bluetooth tun cpufreq_stats rpcsec_gss_krb5 nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc fuse cbc aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod fbcon font bitblit softcursor fb kvm_intel kvm acpi_cpufreq firewire_sbp2 loop snd_hda_intel snd_pcm arc4 snd_seq_midi snd_rawmidi ecb snd_seq_midi_event snd_seq snd_timer ath5k snd_seq_device snd mac80211 soundcore firewire_ohci firewire_core thermal snd_page_alloc cfg80211 i2c_i801 crc_itu_t button processor evdev
>>> Pid: 0, comm: swapper Not tainted 2.6.29-00003-g0be8685 #163 Macmini2,1
>>> RIP: 0010:[<ffffffff803950f0>]  [<ffffffff803950f0>] ioread32+0xf/0x32
>> Huh. I see no reason for this to happen. I suppose this is a regression,
>> which kernel worked?
> 
> I had a previous instance of the problem with v2.6.29-rc8 after about
> six days of uptime.  The kernel before that was 2.6.29-rc7ish, ran OK
> for a couple of days.  But since I don't know how to reproduce it
> reliably it's hard to say which kernel is truly good.
> 
>> There is nothing like "too many interrupts, giving up for now" in dmesg,
>> right?
> 
> No, no messages like that.  I do however get timing-related errors at
> about the time the soft lockup detector indicates the problem began.
> 
> With 2.6.29 I got
> 
>         Mar 29 18:45:48 burly kernel: Clocksource tsc unstable (delta = 532189008 ns)
>         Mar 29 18:46:11 burly kernel: wlan0: No ProbeResp from current AP 00:1a:70:ee:7c:d6 - assume out of range
>         Mar 29 18:46:34 burly kernel: BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]
> 
> and with 2.6.29-rc8 I got
> 
>         Mar 20 21:19:59 burly kernel: CE: hpet increasing min_delta_ns to 22500 nsec

Just a wild guest, finger-to-the-sky, but how about trying with hpet=disable
kernel option?  After all that disasters I've seen with various hpet issues,
every time I see something about it, especially those familiar "CEL hpet
  increasing min_delta" messages, I'm starting trembling again ;)

/mjt
