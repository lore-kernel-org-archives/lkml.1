Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYEZHtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYEZHtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 03:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYEZHtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 03:49:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:6792 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYEZHtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 03:49:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=GLmsiyqebzwyv0wVbDovaP0afBKDtOAfrhoVnspgC0K0lVZrLxWi8eCx3HhpZRnO1tGxzJhRX+7V9zQdGlhs5nOjWCPoeiyecw+a2Wn/rnQk9EJ1+dJCYDmA3dAoOasY8OpSV3C+FPiQXlHWOrw9llrS3Ngd0Wwrg3G8+erViyE=
Message-ID: <19f34abd0805260049j621c882r970444b65e384355@mail.gmail.com>
Date: Mon, 26 May 2008 09:49:41 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Justin Madru" <jdm64@gawab.com>
Subject: Re: Oops in mac80211 with 2.6.26-rc3 triggered playing a video
Cc: lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       "Johannes Berg" <johannes@sipsolutions.net>,
       "Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <483A3F91.6020403@gawab.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_1941_9682671.1211788181436"
References: <483A3F91.6020403@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_1941_9682671.1211788181436
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

On Mon, May 26, 2008 at 6:41 AM, Justin Madru <jdm64@gawab.com> wrote:
> Hi,
>
> I've been getting kernel crashes at random when a video file just starts to
> play (using VLC).
> As soon as the first frame shows, the system locks up hard (sometimes not
> even alt+sysrq+b works).
>
> Just recently, when it crashed it was able to print an oops to the syslog.
> The weird thing is that it says that it's a bug in mac80211? But I only have
> the crash the instant a video file starts to play. (I have an Intel 3945
> wireles, and Intel i945 graphic card)
>
> BUG: unable to handle kernel NULL pointer dereference at 00000090
> IP: [<f89e721f>] :mac80211:ieee80211_associate+0x24f/0x610
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: i915 acpi_cpufreq cpufreq_powersave cpufreq_stats
> cpufreq_userspace cpufreq_conservative container sbs sbshc ext3 jbd mbcache
> arc4 ecb crypto_blkcipher rtc dcdbas cryptomgr crypto_algapi psmouse evdev
> snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm iwl3945 mac80211 snd_timer
> crc32 snd_page_alloc video backlight output ac button battery intel_agp
> reiserfs sr_mod cdrom sg ata_piix ehci_hcd uhci_hcd usbcore thermal
> processor fan
>
> Pid: 1899, comm: iwl3945 Not tainted (2.6.26-rc3-git #1)
> EIP: 0060:[<f89e721f>] EFLAGS: 00010246 CPU: 1
> EIP is at ieee80211_associate+0x24f/0x610 [mac80211]
> EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: f7b85e38
> ESI: f7b85e84 EDI: ecc7122e EBP: f7bbdd34 ESP: f7bbdcc0
> DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> Process iwl3945 (pid: 1899, ti=f7bbd000 task=f718d390 task.ti=f7bbd000)
> Stack: f7b85e84 00000000 f7bbdd14 00000202 f7b85e38 f7b85800 f7f65f00
> 00000018
>      f7bbdcfa 00000000 00000421 00000003 00000006 00000052 f7bbdd0c ecc7122c
>      f71593a4 00000000 f7bbde15 f7bbdd3c c0295679 303a3030 33623a66 3a31613a
> Call Trace:
> [_format_mac_addr+0x79/0x90] ? _format_mac_addr+0x79/0x90
> [sched_debug_show+0x9c6/0xcb0] ? sched_debug_show+0x9c6/0xcb0
> [<f89e7610>] ? ieee80211_auth_completed+0x30/0x40 [mac80211]
> [<f89e7a73>] ? ieee80211_rx_mgmt_auth+0x303/0x4b0 [mac80211]
> [hrtimer_start+0xc2/0x150] ? hrtimer_start+0xc2/0x150
> [hrtick_set+0x85/0x100] ? hrtick_set+0x85/0x100
> [jbd:schedule+0x364/0x8c0] ? schedule+0x364/0x870
> [<f89e7da7>] ? ieee80211_sta_rx_queued_mgmt+0x187/0xcb0 [mac80211]
> [ext3:preempt_schedule+0x33/0x100] ? preempt_schedule+0x33/0x50
> [mac80211:dev_queue_xmit+0xa6/0x1f20] ? dev_queue_xmit+0xa6/0x330
> [mac80211:_spin_unlock_bh+0x18/0xb0] ? _spin_unlock_bh+0x18/0x20
> [<f89e33b7>] ? ieee80211_rx_bss_get+0xa7/0xc0 [mac80211]
> [mac80211:skb_dequeue+0x4d/0x360] ? skb_dequeue+0x4d/0x70
> [<f89e960f>] ? ieee80211_sta_work+0x8f/0x760 [mac80211]
> [hrtick_set+0xa7/0x100] ? hrtick_set+0xa7/0x100
> [jbd:schedule+0x364/0x8c0] ? schedule+0x364/0x870
> [run_workqueue+0x80/0x120] ? run_workqueue+0x80/0x120
> [<f89e9580>] ? ieee80211_sta_work+0x0/0x760 [mac80211]
> [worker_thread+0x88/0xe0] ? worker_thread+0x88/0xe0
> [<c013ba80>] ? autoremove_wake_function+0x0/0x40
> [worker_thread+0x0/0xe0] ? worker_thread+0x0/0xe0
> [kthread+0x42/0x70] ? kthread+0x42/0x70
> [kthread+0x0/0x70] ? kthread+0x0/0x70
> [kernel_thread_helper+0x7/0x18] ? kernel_thread_helper+0x7/0x18
> =======================
> Code: c6 00 00 8b 55 9c 8b 4d c8 8b 42 70 88 41 01 8b 42 70 8b 7d c8 89 c1
> c1 e9 02 83 c7 02 f3 a5 89 c1 83 e1 03 74 02 f3 a4 8b 5d d0 <8b> 9b 90 00 00
> 00 85 db 89 5d d8 0f 84 6d 03 00 00 8b 7d cc 8b
> EIP: [<f89e721f>] ieee80211_associate+0x24f/0x610 [mac80211] SS:ESP
> 0068:f7bbdcc0
> ---[ end trace 7afccad6600bfa21 ]---

The code decodes to:

  1d:   f3 a5                   rep movsl %ds:(%esi),%es:(%edi)
  1f:   89 c1                   mov    %eax,%ecx
  21:   83 e1 03                and    $0x3,%ecx
  24:   74 02                   je     0x28
  26:   f3 a4                   rep movsb %ds:(%esi),%es:(%edi)
  28:   8b 5d d0                mov    -0x30(%ebp),%ebx
   0:   8b 9b 90 00 00 00       mov    0x90(%ebx),%ebx <---- BAM!
   6:   85 db                   test   %ebx,%ebx
   8:   89 5d d8                mov    %ebx,-0x28(%ebp)
   b:   0f 84 6d 03 00 00       je     0x37e
  11:   8b 7d cc                mov    -0x34(%ebp),%edi
  14:   8b                      .byte 0x8b

Recompiling net/mac80211/mlme.c gives me that this happens on line 675.

ieee80211_compatible_rates net/mac80211/mlme.c:675
ieee80211_send_assoc net/mac80211/mlme.c:767
ieee80211_associate net/mac80211/mlme.c:955

So it is in fact compatible_rates() that crashes (but hidden in your
Oops because of heavy inlining).

So looking at the latest changelog in linus/master, we have this change:

commit 0d580a774b3682b8b2b5c89ab9b813d149ef28e7
Author: Helmut Schaa <hschaa@suse.de>
Date:   Tue May 20 09:56:37 2008 +0200

    mac80211: fix NULL pointer dereference in ieee80211_compatible_rates

    Fix a possible NULL pointer dereference in ieee80211_compatible_rates
    introduced in the patch "mac80211: fix association with some APs". If no bss
    is available just use all supported rates in the association request.

    Signed-off-by: Helmut Schaa <hschaa@suse.de>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

So does applying/cherry-picking that fix your problem? (Patch
attached, but not inlined.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036

------=_Part_1941_9682671.1211788181436
Content-Type: text/x-patch; name=mlme.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fgorc5j30
Content-Disposition: attachment; filename=mlme.patch

Y29tbWl0IDBkNTgwYTc3NGIzNjgyYjhiMmI1Yzg5YWI5YjgxM2QxNDllZjI4ZTcKQXV0aG9yOiBI
ZWxtdXQgU2NoYWEgPGhzY2hhYUBzdXNlLmRlPgpEYXRlOiAgIFR1ZSBNYXkgMjAgMDk6NTY6Mzcg
MjAwOCArMDIwMAoKICAgIG1hYzgwMjExOiBmaXggTlVMTCBwb2ludGVyIGRlcmVmZXJlbmNlIGlu
IGllZWU4MDIxMV9jb21wYXRpYmxlX3JhdGVzCiAgICAKICAgIEZpeCBhIHBvc3NpYmxlIE5VTEwg
cG9pbnRlciBkZXJlZmVyZW5jZSBpbiBpZWVlODAyMTFfY29tcGF0aWJsZV9yYXRlcwogICAgaW50
cm9kdWNlZCBpbiB0aGUgcGF0Y2ggIm1hYzgwMjExOiBmaXggYXNzb2NpYXRpb24gd2l0aCBzb21l
IEFQcyIuIElmIG5vIGJzcwogICAgaXMgYXZhaWxhYmxlIGp1c3QgdXNlIGFsbCBzdXBwb3J0ZWQg
cmF0ZXMgaW4gdGhlIGFzc29jaWF0aW9uIHJlcXVlc3QuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6
IEhlbG11dCBTY2hhYSA8aHNjaGFhQHN1c2UuZGU+CiAgICBTaWduZWQtb2ZmLWJ5OiBKb2huIFcu
IExpbnZpbGxlIDxsaW52aWxsZUB0dXhkcml2ZXIuY29tPgoKZGlmZiAtLWdpdCBhL25ldC9tYWM4
MDIxMS9tbG1lLmMgYi9uZXQvbWFjODAyMTEvbWxtZS5jCmluZGV4IGU0NzBiZjEuLjdjZmQxMmUg
MTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS9tbG1lLmMKKysrIGIvbmV0L21hYzgwMjExL21sbWUu
YwpAQCAtNzMwLDcgKzczMCwxNyBAQCBzdGF0aWMgdm9pZCBpZWVlODAyMTFfc2VuZF9hc3NvYyhz
dHJ1Y3QgbmV0X2RldmljZSAqZGV2LAogCQlpZiAoYnNzLT53bW1faWUpIHsKIAkJCXdtbSA9IDE7
CiAJCX0KKworCQkvKiBnZXQgYWxsIHJhdGVzIHN1cHBvcnRlZCBieSB0aGUgZGV2aWNlIGFuZCB0
aGUgQVAgYXMKKwkJICogc29tZSBBUHMgZG9uJ3QgbGlrZSBnZXR0aW5nIGEgc3VwZXJzZXQgb2Yg
dGhlaXIgcmF0ZXMKKwkJICogaW4gdGhlIGFzc29jaWF0aW9uIHJlcXVlc3QgKGUuZy4gRC1MaW5r
IERBUCAxMzUzIGluCisJCSAqIGItb25seSBtb2RlKSAqLworCQlyYXRlc19sZW4gPSBpZWVlODAy
MTFfY29tcGF0aWJsZV9yYXRlcyhic3MsIHNiYW5kLCAmcmF0ZXMpOworCiAJCWllZWU4MDIxMV9y
eF9ic3NfcHV0KGRldiwgYnNzKTsKKwl9IGVsc2UgeworCQlyYXRlcyA9IH4wOworCQlyYXRlc19s
ZW4gPSBzYmFuZC0+bl9iaXRyYXRlczsKIAl9CiAKIAltZ210ID0gKHN0cnVjdCBpZWVlODAyMTFf
bWdtdCAqKSBza2JfcHV0KHNrYiwgMjQpOwpAQCAtNzYxLDEwICs3NzEsNyBAQCBzdGF0aWMgdm9p
ZCBpZWVlODAyMTFfc2VuZF9hc3NvYyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LAogCSpwb3MrKyA9
IGlmc3RhLT5zc2lkX2xlbjsKIAltZW1jcHkocG9zLCBpZnN0YS0+c3NpZCwgaWZzdGEtPnNzaWRf
bGVuKTsKIAotCS8qIGFsbCBzdXBwb3J0ZWQgcmF0ZXMgc2hvdWxkIGJlIGFkZGVkIGhlcmUgYnV0
IHNvbWUgQVBzCi0JICogKGUuZy4gRC1MaW5rIERBUCAxMzUzIGluIGItb25seSBtb2RlKSBkb24n
dCBsaWtlIHRoYXQKLQkgKiBUaGVyZWZvcmUgb25seSBhZGQgcmF0ZXMgdGhlIEFQIHN1cHBvcnRz
ICovCi0JcmF0ZXNfbGVuID0gaWVlZTgwMjExX2NvbXBhdGlibGVfcmF0ZXMoYnNzLCBzYmFuZCwg
JnJhdGVzKTsKKwkvKiBhZGQgYWxsIHJhdGVzIHdoaWNoIHdlcmUgbWFya2VkIHRvIGJlIHVzZWQg
YWJvdmUgKi8KIAlzdXBwX3JhdGVzX2xlbiA9IHJhdGVzX2xlbjsKIAlpZiAoc3VwcF9yYXRlc19s
ZW4gPiA4KQogCQlzdXBwX3JhdGVzX2xlbiA9IDg7Cg==
------=_Part_1941_9682671.1211788181436--
