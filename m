Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbZBXK3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbZBXK3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 05:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZBXK3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 05:29:46 -0500
Received: from www.tglx.de ([62.245.132.106]:44999 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbZBXK3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 05:29:44 -0500
Date: Tue, 24 Feb 2009 11:29:28 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] 2.6.29-rc6-rt2
In-Reply-To: <1235437021.4462.25.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain>
References: <1235437021.4462.25.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009, Fernando Lopez-Lezcano wrote:

> Some feedback, just tried it in Fedora 9...
> 
> (BTW, in Fedora 9 'uname -r' adds a "-tip" component at the end of the
> uname string which messes up loading modules, etc, and it is not
> anywhere else to be seen - where is that coming from??)

My bad. Forgot to remove the localversion-tip file.

> 
> Boots fine but does not last long:
> 
> ------------[ cut here ]------------
> WARNING: at lib/list_debug.c:30 __list_add+0x44/0x5c()
> Hardware name: P5K/EPU
> list_add corruption. prev->next should be next (f6042ab0), but was
> (null). (prev=f415a670).
> Modules linked in: fuse ip6table_filter ip6_tables iptable_raw
> xt_comment xt_recent xt_policy ipt_ULOG ipt_TTL ipt_ttl ipt_REDIRECT
> ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn ipt_CLUSTERIP ipt_ah
> ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip nf_nat_pptp
> nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda ts_kmp
> nf_conntrack_amanda nf_conntrack_tftp nf_conntrack_sip
> nf_conntrack_proto_sctp nf_conntrack_pptp nf_conntrack_proto_gre
> nf_conntrack_netlink nf_conntrack_netbios_ns nf_conntrack_irc
> nf_conntrack_h323 nf_conntrack_ftp xt_tcpmss xt_pkttype xt_physdev
> xt_owner xt_NFQUEUE xt_NFLOG nfnetlink_log xt_multiport xt_MARK xt_mark
> xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSCP
> xt_dscp xt_dccp xt_CONNMARK xt_connmark xt_CLASSIFY iptable_nat nf_nat
> iptable_mangle nfnetlink autofs4 coretemp w83627ehf hwmon_vid hwmon nfs
> lockd nfs_acl auth_rpcgss sunrpc cpufreq_ondemand acpi_cpufreq
> dm_multipath radeon drm ipv6 snd_hda_codec_realtek snd_hda_intel
> snd_hda_codec snd_hwdep snd_ice1712 snd_ice17xx_ak4xxx snd_ak4xxx_adda
> pcspkr snd_cs8427 snd_ac97_codec serio_raw i2c_i801 ac97_bus snd_i2c
> i2c_core iTCO_wdt ohci1394 snd_mpu401_uart iTCO_vendor_support
> snd_rawmidi snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
> snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm joydev snd_timer sky2
> snd soundcore snd_page_alloc [last unloaded: microcode]
> Pid: 5844, comm: slogin Not tainted
> 2.6.29-0.0.rc6.rt2.1.rc6.fc9.ccrma.i686.rtPAE-tip #1
> Call Trace:
>  [<c0438765>] warn_slowpath+0x71/0xa8
>  [<c048183a>] ? cpupri_set+0xdd/0xfb
>  [<c042ace7>] ? update_curr+0x15f/0x167
>  [<c0429dbd>] ? resched_task+0x33/0x6b
>  [<c042ace7>] ? update_curr+0x15f/0x167
>  [<c0543b28>] __list_add+0x44/0x5c
>  [<c0440ef1>] internal_add_timer+0x88/0x8c

Can you try to enable the following config options:

CONFIG_DEBUG_OBJECTS
CONFIG_DEBUG_OBJECTS_FREE
CONFIG_DEBUG_OBJECTS_TIMERS
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT

Thanks,

	tglx

