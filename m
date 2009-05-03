Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZECRP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZECRP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 13:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752720AbZECRPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 13:15:17 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:42064 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZECRPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 13:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=HmktUxrAevIAPvI/4ei0nwm2aspuHllFJ0wzLba8wHIxYuCf8eOVEMI9mDHCrnEokO
         A9JInrJlfYzW/S0/SI/3ERRGA6FPpCn+VwKo7Ek2Nj2PAM4OeMMgXblLD0nkcWpX1qNR
         e07gKCs9qh8VmMRHzJ2XsWf/a1CdLot1fDB+I=
Message-ID: <49FDD11B.40208@gmail.com>
Date: Sun, 03 May 2009 19:15:07 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.30-rc2: WARNING at i915_gem.c for i915_gem_idle
References: <49EE3C1E.8070208@gmail.com>
In-Reply-To: <49EE3C1E.8070208@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Niel Lambrechts wrote:
> Hi there,
>
> I get the following when I switch from runlevel 5 to 3 using the latest
> git kernel. I haven't noticed any other side-effects and X started up
> fine, but I'm assuming something is misbehaving and the trace might be
> meaningful to someone. I also frequently still notice this "*ERROR*
> trying to get vblank count for disabled pipe 0" message when I exit
> Xorg. (BTW, I am still using EXA acceleration due to issues with UXA+KMS).
>
> The hardware is an Lenovo Thinkpad W500 with:
>      00:02.1 Display controller: Intel Corporation Mobile 4 Series
> Chipset Integrated Graphics Controller (rev 07)
>
> messages:
> Apr 21 00:44:00 linux-7vph init: Switching to runlevel: 3
> Apr 21 00:44:06 linux-7vph kernel: ------------[ cut here ]------------
> Apr 21 00:44:06 linux-7vph kernel: WARNING: at
> drivers/gpu/drm/i915/i915_gem.c:3823 i915_gem_idle+0x17a/0x28c [i915]()
> Apr 21 00:44:06 linux-7vph kernel: Hardware name: 40622XG
> Apr 21 00:44:06 linux-7vph kernel: Modules linked in: iwlagn rndis_wlan
> rndis_host cdc_ether usbnet cdc_acm mii usbhid hid cpufreq_stats tun
> i915 drm i2c_algo_bit af_packet ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG
> xt_limit snd_pcm_oss snd_mixer_oss snd_seq binfmt_misc ip6t_REJECT
> nf_conntrack_ipv6 ip6table_raw xt_NOTRACK ipt_REJECT xt_state
> iptable_raw iptable_filter ip6table_mangle cpufreq_conservative
> cpufreq_userspace nf_conntrack_netbios_ns cpufreq_powersave
> nf_conntrack_ipv4 acpi_cpufreq nf_conntrack nf_defrag_ipv4 ip_tables
> speedstep_lib ip6table_filter ip6_tables x_tables ipv6 microcode fuse
> loop dm_mod snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device
> snd_hda_codec_conexant arc4 snd_hda_intel ecb snd_hda_codec snd_hwdep
> snd_pcm iwlcore snd_timer thinkpad_acpi snd mac80211 soundcore rtc_cmos
> video rfkill led_class intel_agp iTCO_wdt output rtc_core snd_page_alloc
> ohci1394 i2c_i801 button sr_mod wmi battery ac e1000e rtc_lib agpgart
> cfg80211 nvram joydev i2c_core cdrom iTCO_vendor_support sg ieee1394
> sd_mod us
> Apr 21 00:44:06 linux-7vph kernel: bcore ext4 jbd2 crc16 edd ext3
> mbcache jbd fan ahci libata scsi_mod thermal processor [last unloaded:
> iwlagn]
> Apr 21 00:44:06 linux-7vph kernel: Pid: 3193, comm: Xorg Not tainted
> 2.6.30-rc2-pae #24
> Apr 21 00:44:06 linux-7vph kernel: Call Trace:
> Apr 21 00:44:06 linux-7vph kernel:  [<c0127768>] warn_slowpath+0x71/0xa0
> Apr 21 00:44:06 linux-7vph kernel:  [<c012f66f>] ? del_timer_sync+0xd/0x18
> Apr 21 00:44:06 linux-7vph kernel:  [<c030573c>] ?
> schedule_timeout+0x154/0x16a
> Apr 21 00:44:06 linux-7vph kernel:  [<c01354f3>] ?
> __cancel_work_timer+0x124/0x162
> Apr 21 00:44:06 linux-7vph kernel:  [<f82df3ba>] ?
> i915_gem_retire_requests+0x141/0x15b [i915]
> Apr 21 00:44:06 linux-7vph kernel:  [<f82e07e2>]
> i915_gem_idle+0x17a/0x28c [i915]
> Apr 21 00:44:06 linux-7vph kernel:  [<f82e0947>]
> i915_gem_leavevt_ioctl+0x1f/0x2e [i915]
> Apr 21 00:44:06 linux-7vph kernel:  [<f828574c>] drm_ioctl+0x1f6/0x27c [drm]
> Apr 21 00:44:06 linux-7vph kernel:  [<f82e0928>] ?
> i915_gem_leavevt_ioctl+0x0/0x2e [i915]
> Apr 21 00:44:06 linux-7vph kernel:  [<c0305dc0>] ? mutex_lock+0xe/0x28
> Apr 21 00:44:06 linux-7vph kernel:  [<f7ee5640>] ?
> agpioc_release_wrap+0x57/0x5b [agpgart]
> Apr 21 00:44:06 linux-7vph kernel:  [<f7ee6279>] ? agp_ioctl+0x3b6/0x3d9
> [agpgart]
> Apr 21 00:44:06 linux-7vph kernel:  [<c013ef0f>] ? getnstimeofday+0x51/0xda
> Apr 21 00:44:06 linux-7vph kernel:  [<c0196b3a>] vfs_ioctl+0x50/0x69
> Apr 21 00:44:06 linux-7vph kernel:  [<c0196fac>] do_vfs_ioctl+0x459/0x492
> Apr 21 00:44:06 linux-7vph kernel:  [<c01047fe>] ? timer_interrupt+0x3a/0x41
> Apr 21 00:44:06 linux-7vph kernel:  [<c0158a2a>] ?
> handle_IRQ_event+0x8c/0x142
> Apr 21 00:44:06 linux-7vph kernel:  [<c0306e6f>] ? _spin_lock+0x8/0xb
> Apr 21 00:44:06 linux-7vph kernel:  [<c0159d5a>] ?
> handle_edge_irq+0x108/0x111
> Apr 21 00:44:06 linux-7vph kernel:  [<c012bcaa>] ? __do_softirq+0x12b/0x133
> Apr 21 00:44:06 linux-7vph kernel:  [<c0197025>] sys_ioctl+0x40/0x5a
> Apr 21 00:44:06 linux-7vph kernel:  [<c01029d4>] sysenter_do_call+0x12/0x28
> Apr 21 00:44:06 linux-7vph kernel: ---[ end trace e40fb1797bec2bee ]---
> Apr 21 00:44:06 linux-7vph kernel: [drm:gm45_get_vblank_counter] *ERROR*
> trying to get vblank count for disabled pipe 0
> Apr 21 00:44:10 linux-7vph bonobo-activation-server (niella-19973):
> could not associate with desktop session: Failed to connect to socket
> /tmp/dbus-uxRGFTgO2e: Connection refused
> Apr 21 00:44:31 linux-7vph init: Switching to runlevel: 5
Hi,

Just to let you know, the warning still persists with 2.6.30-rc4:

[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for
disabled pipe 0         
------------[ cut here
]------------                                                         
WARNING: at drivers/gpu/drm/i915/i915_gem.c:3823
i915_gem_idle+0x17a/0x28c [i915]()          
Hardware name:
40622XG                                                                       

Modules linked in: nls_utf8 tun cpufreq_stats i915 drm i2c_algo_bit
af_packet ip6t_LOG xt_tcpudp xt_pkttype ipt_LOG xt_limit snd_pcm_oss
snd_mixer_oss snd_seq binfmt_misc ip6t_REJECT nf_conntrack_ipv6
ip6table_raw cpufreq_conservative cpufreq_userspace cpufreq_powersave
xt_NOTRACK acpi_cpufreq ipt_REJECT xt_state speedstep_lib iptable_raw
iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_ipv4
nf_conntrack nf_defrag_ipv4 ip_tables ip6table_filter ip6_tables
x_tables ipv6 microcode fuse loop dm_mod snd_usb_audio snd_usb_lib
snd_rawmidi snd_seq_device arc4 ecb iwlagn snd_hda_codec_conexant
iwlcore snd_hda_intel snd_hda_codec thinkpad_acpi snd_hwdep rfkill
led_class snd_pcm mac80211 snd_timer video i2c_i801 nvram intel_agp
output rtc_cmos ac battery e1000e snd ohci1394 wmi cfg80211 i2c_core
rtc_core soundcore sr_mod cdrom agpgart button ieee1394 rtc_lib joydev
iTCO_wdt snd_page_alloc sg iTCO_vendor_support sd_mod usbcore ext4 jbd2
crc16 edd ext3 mbcache jbd fan ahci libata scsi_mod thermal processor
[last unloaded:
uhci_hcd]                                                                         

Pid: 6232, comm: Xorg Tainted: G        W  2.6.30-rc4-pae
#39                                
Call
Trace:                                                                                  

 [<c01274dc>]
warn_slowpath+0x71/0xa0                                                        

 [<c012f3c3>] ?
del_timer_sync+0xd/0x18                                                      

 [<c0303f75>] ?
schedule_timeout+0x154/0x16a                                                 

 [<c0135247>] ?
__cancel_work_timer+0x124/0x162                                              

 [<f89b64d0>] ? i915_gem_retire_requests+0x141/0x15b
[i915]                                  
 [<f89b7919>] i915_gem_idle+0x17a/0x28c
[i915]                                               
 [<f89b7a7e>] i915_gem_leavevt_ioctl+0x1f/0x2e
[i915]                                        
 [<f87c274c>] drm_ioctl+0x1f6/0x27c
[drm]                                                    
 [<f89b7a5f>] ? i915_gem_leavevt_ioctl+0x0/0x2e
[i915]                                       
 [<c03045f9>] ?
mutex_lock+0xe/0x28                                                          

 [<f83b7648>] ? agpioc_release_wrap+0x57/0x5b
[agpgart]                                      
 [<f83b8281>] ? agp_ioctl+0x3b6/0x3d9
[agpgart]                                              
 [<c010185b>] ?
__switch_to+0x10c/0x14b                                                      

 [<c01238f5>] ?
finish_task_switch+0x47/0xcb                                                 

 [<c019651e>]
vfs_ioctl+0x50/0x69                                                            

 [<c0196990>]
do_vfs_ioctl+0x459/0x492                                                       

 [<c012ba02>] ?
__do_softirq+0x12b/0x133                                                     

 [<c0196a09>]
sys_ioctl+0x40/0x5a                                                            

 [<c01029d4>]
sysenter_do_call+0x12/0x28                                                     

---[ end trace 2f94d791b22c4564
]---                                                         
[drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for
disabled pipe 0         
mtrr: no MTRR for d0000000,10000000
found                                                    
CPU0 attaching NULL
sched-domain.                                                            
CPU1 attaching NULL
sched-domain.                                                            
CPU0 attaching
sched-domain:                                                                 

 domain 0: span 0-1 level
MC                                                                 
  groups: 0
1                                                                                

  domain 1: span 0-1 level
CPU                                                               
   groups: 0-1 (__cpu_power =
2048)                                                          
CPU1 attaching
sched-domain:                                                                 

 domain 0: span 0-1 level
MC                                                                 
  groups: 1
0                                                                                

  domain 1: span 0-1 level
CPU                                                               
   groups: 0-1 (__cpu_power =
2048)                                                          
ISO 9660 Extensions: Microsoft Joliet Level
3                                                
ISO 9660 Extensions: RRIP_1991A
---

Regards,
Niel
