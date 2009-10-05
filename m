Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbZJEVHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbZJEVHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZJEVHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:07:19 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:38428 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbZJEVHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:07:17 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 17:07:16 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=VUj+8KYMEeKKeoJoLxd6c5p2WzYK61RIUwxheCKFNvp5AwWQrX4F6lstYpEl5k9rwq
         zy6lCei1WXHexgqR+U1C1Kjn0ZK0HO1qy/pCUkw7Je0zH8AXaj3nNSlkZVwqyrr6KAys
         dnAqobnBt3JlRTSu1pyuWPVG8Z19eN/GV3HcE=
Message-ID: <4ACA5E3D.1020108@tuffmail.co.uk>
Date: Mon, 05 Oct 2009 21:59:41 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] 2.6.32-rc1: various BUGs on resume from hibernation
References: <4AC8B4A8.3050601@tuffmail.co.uk>	<4AC8D568.9090103@tuffmail.co.uk>	<200910042247.43528.rjw@sisk.pl> <20091005095327.5ea9831b@strolchi> <4ACA50DD.9050801@tuffmail.co.uk>
In-Reply-To: <4ACA50DD.9050801@tuffmail.co.uk>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Stefan Seyfried wrote:
>> On Sun, 4 Oct 2009 22:47:43 +0200
>> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>>> On Sunday 04 October 2009, Alan Jenkins wrote:
>>>> Alan Jenkins wrote:
>>>>> I'm seeing a variety of BUGs on my EeePC 701 after hibernation. 
>>>>> Sometimes they cause a hang during resume; sometimes they happen
>>>>> just after resume. It doesn't happen all the time either - I've
>>>>> just hibernated three times in a row with no problems. It's most
>>>>> perplexing.
>>
>>> As I already asked in the Bugzilla, can you verify that this is
>>> reproducible without KMS?
>
> No. I couldn't reproduce it without KMS. Then I re-enabled KMS, 
> hibernated a couple of times, and had another resume hang (different 
> again - this time in the freezer).
>

Perhaps this GEM backtrace is more relevant than the others, or perhaps 
not. I closed the lid during resume from hibernation; the screen stayed 
black when I re-opened it, but syslogd recorded the following. (Again, 
I've done the exact thing before and often nothing unusual happens) -

207.793317] ACPI: Waking up from system sleep state S4
208.480594] [drm] LVDS-8: set mode 800x480 1c
209.022770] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
...
209.653483] usb 1-8: reset high speed USB device using ehci_hcd and address 3
210.134607] Restarting tasks ... done.
210.743796] ADDRCONF(NETDEV_UP): eth0: link is not ready
210.860322] ADDRCONF(NETDEV_UP): wlan0: link is not ready
211.352971] *pdpt = 00000000175e7001 *pde = 0000000000000000
211.353006] Modules linked in: af_packet fbcon tileblit font bitblit softcursor i915 drm_kms_helper drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect ipv6 loop joydev snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss ath5k snd_mixer_oss mac80211 ath snd_pcm uvcvideo cfg80211 psmouse i2c_i801 snd_timer videodev v4l1_compat eeepc_laptop snd serio_raw pcspkr i2c_core rfkill battery ac pci_hotplug snd_page_alloc evdev processor intel_agp video backlight output agpgart button thermal fan [last unloaded: scsi_wait_scan]
211.353126]
211.353137] Pid: 1933, comm: Xorg Not tainted (2.6.32-rc2eeepc-test #505) 701
211.353147] EIP: 0060:[<e02930fa>] EFLAGS: 00213246 CPU: 0
211.353187] EIP is at i915_gem_object_get_pages+0x96/0xf4 [i915]
(i915_gem_object_get_pages (drivers/gpu/drm/i915/i915_gem.c:2238)


00009064 <i915_gem_object_get_pages>:
...
(0x9064 + 0x96 = 0x90fa)
...
    90de:       85 d2                   test   %edx,%edx
    90e0:       89 53 24                mov    %edx,0x24(%ebx)
    90e3:       75 0a                   jne    90ef <i915_gem_object_get_pages+0x8b>
    90e5:       ff 4b 28                decl   0x28(%ebx)
    90e8:       be f4 ff ff ff          mov    $0xfffffff4,%esi
    90ed:       eb 5f                   jmp    914e <i915_gem_object_get_pages+0xea>
    90ef:       8b 55 e8                mov    -0x18(%ebp),%edx
    90f2:       31 ff                   xor    %edi,%edi
    90f4:       8b 42 0c                mov    0xc(%edx),%eax
    90f7:       8b 40 0c                mov    0xc(%eax),%eax
    90fa:       8b 40 0c                mov    0xc(%eax),%eax
    90fd:       8b 80 98 00 00 00       mov    0x98(%eax),%eax
    9103:       89 45 f0                mov    %eax,-0x10(%ebp)
    9106:       eb 31                   jmp    9139 <i915_gem_object_get_pages+0xd5>
    9108:       8b 55 f0                mov    -0x10(%ebp),%edx
    910b:       8b 42 30                mov    0x30(%edx),%eax
    910e:       89 fa                   mov    %edi,%edx
    9110:       8b 48 04                mov    0x4(%eax),%ecx
    9113:       8b 45 f0                mov    -0x10(%ebp),%eax
    9116:       6a 00                   push   $0x0
    9118:       e8 fc ff ff ff          call   9119 <i915_gem_object_get_pages+0xb5>
...


211.353197] EAX: 00000000 EBX: dbeafb80 ECX: 00000008 EDX: dbeb68a0
211.353206] ESI: dbeb68a0 EDI: 00000000 EBP: d74cfd8c ESP: d74cfd74
211.353216]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
211.353239]  dbeb68a0 00000001 dbeafb80 dbeafb80 dbeb68a0 dbd53c00 d74cfdb4 e029435c
211.353258] <0> dc341d28 00001000 dc341000 00296e52 fffffff0 dbe22800 dbd53c00 dbeafb80
211.353277] <0> d74cfdcc e029447f dbeb68a0 dbe22800 dbeafb80 de2baa20 d74cfe80 e0297090
211.353323]  [<e029435c>] ? i915_gem_object_bind_to_gtt+0x10a/0x210 [i915]
(drivers/gpu/drm/i915/i915_gem.c:2615)

211.353323]  [<e029447f>] ? i915_gem_object_pin+0x1d/0x117 [i915]
(drivers/gpu/drm/i915/i915_gem.c:3857)

211.353323]  [<e0297090>] ? i915_gem_execbuffer+0x4af/0x1031 [i915]
(drivers/gpu/drm/i915/i915_gem.c:3178)

211.353323]  [<c02ed818>] ? __kfree_skb+0x66/0x69
211.353323]  [<e029c95b>] ? intel_mark_busy+0x3a/0xb3 [i915]
(drivers/gpu/drm/i915/intel_display.c:2263)

211.353323]  [<e01c155c>] ? drm_ioctl+0x1e8/0x259 [drm]
(drivers/gpu/drm/drm_drv.c:476)

211.353323]  [<e0296be1>] ? i915_gem_execbuffer+0x0/0x1031 [i915]
211.353323]  [<c010aae7>] ? sched_clock+0xb/0x1c
211.353323]  [<c0142b23>] ? sched_clock_local+0x11/0x134
211.353323]  [<e01c1374>] ? drm_ioctl+0x0/0x259 [drm]
211.353323]  [<c01a47f8>] ? vfs_ioctl+0x3c/0x4f
211.353323]  [<c01a507c>] ? do_vfs_ioctl+0x474/0x4ac
211.353323]  [<c0123fad>] ? set_next_entity+0x1d/0x83
211.353323]  [<c0124097>] ? pick_next_task_fair+0x5b/0x6e
211.353323]  [<c0343fa4>] ? schedule+0x175/0x3e6
211.353323]  [<c01a50e0>] ? sys_ioctl+0x2c/0x45
211.353323]  [<c0107154>] ? sysenter_do_call+0x12/0x28
211.353960] ---[ end trace 99be0f1305a0c4a1 ]---
Oct  5 21:10:37 alan-eeepc kernel: [  219.229840] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Oct  5 21:11:13 alan-eeepc kernel: [  255.136410] SysRq : Emergency Sync

