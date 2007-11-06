Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbXKFCqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbXKFCqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 21:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbXKFCqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 21:46:37 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:7672 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbXKFCqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 21:46:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=i8l0+QtKTxc07C1TmGrC06c8NQMkG+nyC6EHU6/o3Gm61LrzIIYhw3ho5GFkiSF1OXhBoIunyRJB0k3a29l1Vsi8HqZYyifKyqLmFTSKtczLrunw2ktuR94tUv7Z0Qpisv1hPSr3YsJSpRUxzuykRv78xXDXCBpsRwf/HfK9itY=
Message-ID: <a8e1da0711051846u1b0a4e3he1226bcaf321eab0@mail.gmail.com>
Date: Tue, 6 Nov 2007 10:46:32 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Subject: Re: Warnings and Oops on 2.6.23-rc6 while activily using rfcomm links (mm/slab.c)
Cc: "Pierre-Yves Paulus" <py@idlum.be>, linux-kernel@vger.kernel.org,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "BlueZ development" <bluez-devel@lists.sourceforge.net>,
       "Marcel Holtmann" <marcel@holtmann.org>
In-Reply-To: <20071001143230.3c370b2e@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_26981_5171473.1194317192896"
References: <46F92364.3080603@idlum.be> <46FA5E2E.3010300@idlum.be>
	 <20070927085658.1c66f1c8@gondolin.boeblingen.de.ibm.com>
	 <46FBC1AE.4020404@idlum.be> <46FBF17A.6030009@idlum.be>
	 <20070928085438.4eb5a38f@gondolin.boeblingen.de.ibm.com>
	 <46FD1200.9020407@idlum.be> <46FD1670.5070109@idlum.be>
	 <46FD2CA0.3050704@idlum.be>
	 <20071001143230.3c370b2e@gondolin.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_26981_5171473.1194317192896
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 10/1/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> On Fri, 28 Sep 2007 18:32:32 +0200,
> Pierre-Yves Paulus <py@idlum.be> wrote:
>
> This looks more informational, thanks.
>
> > DEV: Unregistering device. ID = 'rfcomm0'
> > PM: Removing info for No Bus:rfcomm0
> > kobject_uevent_env
> > fill_kobj_path: path = '/class/tty/rfcomm0'
> > fill_kobj_path: path =
> > '/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
> > kobject rfcomm0: cleaning up
> > device_create_release called for rfcomm0
>
> Here rfcomm0 was unregistered and released.
>
> > bus bluetooth: remove device acl00126253F906
> > PM: Removing info for bluetooth:acl00126253F906
> > kobject_uevent_env
> > fill_kobj_path: path =
> > '/devices/pci0000:00/0000:00:0f.4/usb1/1-1/1-1.5/1-1.5.1/1-1.5.1:1.0/hci2/acl00126253F906'
> > kobject acl00126253F906: cleaning up
>
> And here the corresponding physdev.
>
> > BUG: unable to handle kernel NULL pointer dereference at virtual address
> > 00000000
> >   printing eip:
> > c0249e29
> > *pde = 00000000
> > Oops: 0000 [#1]
> > Modules linked in: rfcomm l2cap battery ipv6 dm_snapshot dm_mirror
> > dm_mod softdog loop parport_pc parport floppy rtc pcspkr ac button
> > psmouse serio_raw snd_cs5535audio snd_ac97_codec ac97_bus snd_pcm
> > snd_timer snd soundcore snd_page_alloc geode_rng cs5535_gpio hci_usb
> > bluetooth geode_aes blkcipher tsdev evdev usbhid hid reiserfs ide_disk
> > generic amd74xx ide_core ohci_hcd sata_via ata_generic 8139cp libata
> > 8139too usbcore mii scsi_mod thermal processor fan
> > CPU:    0
> > EIP:    0060:[<c0249e29>]    Not tainted VLI
> > EFLAGS: 00010017   (2.6.23-rc8 #1)
> > EIP is at skb_dequeue+0x23/0x4a
> > eax: 00000282   ebx: 00000282   ecx: 00000000   edx: caf8ab8c
> > esi: c8428d48   edi: c8428c00   ebp: c8428c0c   esp: c124ff60
> > ds: 007b   es: 007b   fs: 0000  gs: 0000  ss: 0068
> > Process events/0 (pid: 5, ti=c124e000 task=c1243500 task.ti=c124e000)
> > Stack: caf8ab8c c024b0a1 c8428c00 d02f4075 c8428d60 c020eb8d c08978a8
> > 00000000
> >         00000000 00000000 cf7ab680 c8428d48 c020eac4 00000000 c01279a9
> > c124ffb4
> >         00000046 c1243500 cf7ab680 cf7ab680 c0127ffe c124ffd0 c01280b0
> > 00000000
> > Call Trace:
> >   [<c024b0a1>] skb_queue_purge+0x11/0x17
> >   [<d02f4075>] rfcomm_tty_flush_buffer+0x1c/0x33 [rfcomm]
> >   [<c020eb8d>] do_tty_hangup+0xc9/0x2d0
> >   [<c020eac4>] do_tty_hangup+0x0/0x2d0
> >   [<c01279a9>] run_workqueue+0x7d/0x103
> >   [<c0127ffe>] worker_thread+0x0/0xbe
> >   [<c01280b0>] worker_thread+0xb2/0xbe
> >   [<c012a510>] autoremove_wake_function+0x0/0x35
> >   [<c012a363>] kthread+0x36/0x5b
> >   [<c012a32d>] kthread+0x0/0x5b
> >   [<c0104e17>] kernel_thread_helper+0x7/0x10
> >   =======================
>
> rfcomm0 is already freed, maybe this code is still trying to access it?
>
> > Code: 89 42 0a 5b 5e 5f 5d c3 53 89 c2 9c 58 90 8d b4 26 00 00 00 00 89
> > c3 fa 90 8d b4 26 00 00 00 00 90 8b 0a 39 d1 75 04 31 c9 eb 17 <8b> 01
> > ff 4a 08 89 02 89 50 04 c7 01 00 00 00 00 c7 41 04 00 00
> > EIP: [<c0249e29>] skb_dequeue+0x23/0x4a SS:ESP 0068:c124ff60
> > WARNING: at lib/kref.c:33 kref_get()
> >   [<c01c6db7>] kref_get+0x34/0x3d
> >   [<c01c61a9>] kobject_get+0xf/0x13
> >   [<c022578d>] get_device+0xe/0x14
> >   [<c02257a6>] device_move+0x13/0x114
> >   [<d02f4b7c>] rfcomm_tty_close+0x23/0x61 [rfcomm]
> >   [<c020f88d>] release_dev+0x1c0/0x54e
> >   [<d02f40e5>] rfcomm_dev_destruct+0x59/0x65 [rfcomm]
> >   [<d02f4725>] rfcomm_dev_ioctl+0x329/0x4d0 [rfcomm]
> >   [<c0130c96>] tick_program_event+0x2a/0x49
> >   [<c0248124>] release_sock+0xc/0x74
> >   [<c020fc22>] tty_release+0x7/0xa
> >   [<c015dabd>] __fput+0x93/0x147
> >   [<c015b66a>] filp_close+0x51/0x58
> >   [<c02a8b0e>] __sched_text_start+0x1d6/0x245
> >   [<c015c70b>] sys_close+0x54/0x83
> >   [<c0103c72>] syscall_call+0x7/0xb
> >   =======================
> > DEVICE: moving 'rfcomm0' to '<NULL>'
> > kobject <NULL>: cleaning up
> > device_create_release called for rfcomm0
>
> But here someone still tries to move rfcomm0 around? It already is gone
> and released... The code path has no reference on rfcomm0. (Well,
> device_move() tries to get a reference on the device to be moved, but
> that doesn't help since the device is already gone.)
>
> This looks like a race inside rfcomm. The device_unregister() either
> needs to be delayed until after device_move() has finished, or the
> thread calling device_move() needs to have a reference. (device_move()
> on an unregistered device should just fail but not oops.) Marcel?
> -
Hi,
please try the attached patch.
or the one by marcel in http://lkml.org/lkml/2007/11/5/111

Please tell me the result, thanks.

Regards
dave

------=_Part_26981_5171473.1194317192896
Content-Type: application/octet-stream; name=diff.rfcomm
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f8ntqq3i
Content-Disposition: attachment; filename=diff.rfcomm

U2lnbmVkLW9mZi1ieTogRGF2ZSBZb3VuZyA8aGlkYXZlLmRhcmtzdGFyQGdtYWlsLmNvbT4gCgot
LS0KbmV0L2JsdWV0b290aC9yZmNvbW0vdHR5LmMgfCAgICA3IC0tLS0tLS0KMSBmaWxlIGNoYW5n
ZWQsIDcgZGVsZXRpb25zKC0pCgpkaWZmIC11cHIgbGludXgvbmV0L2JsdWV0b290aC9yZmNvbW0v
dHR5LmMgbGludXgubmV3L25ldC9ibHVldG9vdGgvcmZjb21tL3R0eS5jCi0tLSBsaW51eC9uZXQv
Ymx1ZXRvb3RoL3JmY29tbS90dHkuYwkyMDA3LTExLTA1IDExOjI4OjQ5LjAwMDAwMDAwMCArMDgw
MAorKysgbGludXgubmV3L25ldC9ibHVldG9vdGgvcmZjb21tL3R0eS5jCTIwMDctMTEtMDUgMTE6
MzA6NTkuMDAwMDAwMDAwICswODAwCkBAIC0xMDE4LDEzICsxMDE4LDYgQEAgc3RhdGljIHZvaWQg
cmZjb21tX3R0eV9oYW5ndXAoc3RydWN0IHR0eQogCQlyZXR1cm47CiAKIAlyZmNvbW1fdHR5X2Zs
dXNoX2J1ZmZlcih0dHkpOwotCi0JaWYgKHRlc3RfYml0KFJGQ09NTV9SRUxFQVNFX09OSFVQLCAm
ZGV2LT5mbGFncykpIHsKLQkJaWYgKHJmY29tbV9kZXZfZ2V0KGRldi0+aWQpID09IE5VTEwpCi0J
CQlyZXR1cm47Ci0JCXJmY29tbV9kZXZfZGVsKGRldik7Ci0JCXJmY29tbV9kZXZfcHV0KGRldik7
Ci0JfQogfQogCiBzdGF0aWMgaW50IHJmY29tbV90dHlfcmVhZF9wcm9jKGNoYXIgKmJ1ZiwgY2hh
ciAqKnN0YXJ0LCBvZmZfdCBvZmZzZXQsIGludCBsZW4sIGludCAqZW9mLCB2b2lkICp1bnVzZWQp
Cg==
------=_Part_26981_5171473.1194317192896--
