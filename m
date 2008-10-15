Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYJOQm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYJOQm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYJOQmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:42:49 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:46570 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346AbYJOQms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=xdZTocdHpKtyBmApmQRvktin8Am/P3ZcuZePIz5B2/q3c6p38tNGazsYfk57+0dPL/
         X9+g7JbCnBV24TTTXcBtR/fQXi27N1zf7RHpZJAcwgunL8BJ0D25bTF+GkhubdyuEmO7
         FM3HQQ7CRE6O2pv+BO/5MTyvj1au5tb2KHKdI=
Message-ID: <48F61DA1.6060504@tuffmail.co.uk>
Date: Wed, 15 Oct 2008 17:43:13 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: linux-uvc-devel@lists.berlios.de,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-uvc-devel] [BUG] NULL pointer dereference caused by uvcvideo
 stress test
References: <gbiduj$9p3$1@ger.gmane.org> <200810151417.14661.laurent.pinchart@skynet.be>
In-Reply-To: <200810151417.14661.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> Hi Alan,
>
> On Friday 26 September 2008, Alan Jenkins wrote:
>   
>> This is is on v2.6.27-rc6.  I originally saw it on todays -tip tree.
>>
>> # while true; do modprobe uvcvideo; modprobe -r uvcvideo; done
>>
>> After a few tens of cycles, modprobe gets stuck in "D" state, and the
>> following backtrace appears:
>>     
>
> [snip]
>
> I can't reproduce the issue here on 2.6.27. Could you please test that 
> version ?
>   

Sure... still happens.

If you look at the trace, it happens as "hald-probe-video" opens the 
video device.  This is from Ubuntu 8.04.  Possibly it's significant that 
I use the camera first, to make sure it works (I use Kopete, the 
settings dialogue includes a video test).

[  267.056655] input: UVC Camera (eb1a:2761) as /class/input/input59
[  267.069990] usbcore: registered new interface driver uvcvideo
[  267.069990] USB Video Class driver (v0.1.0)
[  267.299989] usbcore: deregistering interface driver uvcvideo
[  267.336656] Linux video capture interface: v2.00
[  267.349981] uvcvideo: Found UVC 1.00 device <unnamed> (eb1a:2761)
[  267.353317] input: UVC Camera (eb1a:2761) as /class/input/input60
[  267.363324] usbcore: registered new interface driver uvcvideo
[  267.363324] USB Video Class driver (v0.1.0)
[  267.373325] BUG: unable to handle kernel NULL pointer dereference at 
00000030
[  267.373325] IP: [<e03e13ec>] :videodev:video_open+0x8b/0xe4
[  267.373325] *pdpt = 0000000011ebc001 *pde = 0000000000000000
[  267.373325] Oops: 0000 [#1]
[  267.373325] Modules linked in: uvcvideo(-) compat_ioctl32 videodev 
v4l1_compat aes_i586 aes_generic af_packet i915 drm cpufreq_userspace 
cpufreq_powersave cpufreq_ondemand cpufreq_stats freq_table 
cpufreq_conservative wmi sbs sbshc ip6t_LOG nf_conntrack_ipv6 ipt_LOG 
xt_limit ipt_addrtype xt_state xt_tcpudp xt_conntrack ip6table_filter 
ip6_tables ipv6 nf_nat_irc nf_conntrack_irc nf_nat_ftp nf_nat 
nf_conntrack_ipv4 nf_conntrack_ftp nf_conntrack iptable_filter ip_tables 
x_tables dm_crypt dm_mod fuse joydev arc4 ecb crypto_blkcipher ath5k 
mac80211 led_class sg cfg80211 psmouse serio_raw snd_hda_intel 
snd_pcm_oss snd_mixer_oss ata_generic snd_pcm snd_timer snd_page_alloc 
snd_hwdep shpchp pci_hotplug intel_agp agpgart video output battery ac 
eeepc_laptop backlight button evdev uhci_hcd ehci_hcd usb_storage 
libusual pcspkr usbcore thermal processor fan [last unloaded: v4l1_compat]
[  267.373325]
[  267.373325] Pid: 7709, comm: hald-probe-vide Not tainted (2.6.27eeepc 
#61)
[  267.373325] EIP: 0060:[<e03e13ec>] EFLAGS: 00010246 CPU: 0
[  267.373325] EIP is at video_open+0x8b/0xe4 [videodev]
[  267.373325] EAX: 00000000 EBX: e03e49d0 ECX: e03e1361 EDX: d1e6c000
[  267.373325] ESI: d1ea5c80 EDI: 00000000 EBP: debf41ec ESP: d1efde98
[  267.373325]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  267.373325] Process hald-probe-vide (pid: 7709, ti=d1efc000 
task=d1c586e0 task.ti=d1efc000)
[  267.373325] Stack: 00000000 df1e17c0 00000000 debf41ec c01604e6 
d1ea5c80 00000000 d1ea5c80
[  267.373325]        debf41ec d1efdf14 c0160406 c015d36d deae0580 
def61700 d1efdf14 d1ea5c80
[  267.373325]        d1efdf14 00008001 c015d471 d1ea5c80 00000000 
00000000 d1efdf14 c016692e
[  267.373325] Call Trace:
[  267.373325]  [<c01604e6>] chrdev_open+0xe0/0xf6
[  267.373325]  [<c0160406>] chrdev_open+0x0/0xf6
[  267.373325]  [<c015d36d>] __dentry_open+0xf2/0x1da
[  267.373325]  [<c015d471>] nameidata_to_filp+0x1c/0x2c
[  267.373325]  [<c016692e>] do_filp_open+0x343/0x61e
[  267.373325]  [<c014e1ad>] handle_mm_fault+0x27d/0x528
[  267.373325]  [<c016df2d>] alloc_fd+0x46/0xad
[  267.373325]  [<c015d1a8>] do_sys_open+0x3f/0xb3
[  267.373325]  [<c015d260>] sys_open+0x1e/0x23
[  267.373325]  [<c01035c1>] sysenter_do_call+0x12/0x21
[  267.373325]  [<c0280000>] xfrm_state_find+0x3bb/0x4b1
[  267.373325]  =======================
[  267.373325] Code: c4 0c 85 d2 74 6d 8b 02 8b 5e 10 85 c0 74 15 8b 00 
85 c0 74 0b 83 38 02 74 0a ff 80 40 01 00 00 8b 02 eb 02 31 c0 89 46 10 
31 ff <8b> 48 30 85 c9 74 36 89 f2 89 e8 ff d1 85 c0 89 c7 74 2a 8b 46
[  267.373325] EIP: [<e03e13ec>] video_open+0x8b/0xe4 [videodev] SS:ESP 
0068:d1efde98
[  267.373325] ---[ end trace 1a1a7d2a0a55bf75 ]---
[  267.379201] usbcore: deregistering interface driver uvcvideo

