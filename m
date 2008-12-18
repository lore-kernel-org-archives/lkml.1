Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752853AbYLRGsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbYLRGsT (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 01:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYLRGsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 01:48:03 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:35791 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYLRGsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 01:48:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lUYhlkmvN5OcviwcmUVjA1MVfxQW/znQjJDbvTXeGIlf/Ovio59+cnpKlue5czPFq7
         apgb0UA+4sweWSxValIc4LGLZY7JxvIIYEOtHUf4LRnN2pmZkmjCIQyy4WrbRUOQytZJ
         pm4c7GGWXCV8SsFUqHpl8Kdo2fHr/FOFCwT+Q=
Message-ID: <21d7e9970812172247t3d67e6f0waffa99587e2e024b@mail.gmail.com>
Date: Thu, 18 Dec 2008 16:47:59 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Kevin Winchester" <kjwinchester@gmail.com>
Subject: Re: linux-next: Tree for December 17 (Radeon DRM BUG)
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Dave Airlie" <airlied@redhat.com>
In-Reply-To: <494995D7.6090009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081217232536.0b18f4a7.sfr@canb.auug.org.au>
	 <494995D7.6090009@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2008 at 10:14 AM, Kevin Winchester
<kjwinchester@gmail.com> wrote:
> Stephen Rothwell wrote:
>>
>> Hi all,
>>
>>
>
> I get the following BUG in the radeon drm code with today's linux-next when
> I run "startx".  I have not built or tested linux-next in a while, but the
> problem definitely does not occur in mainline.

Do you have another X server running or just console?

can you get a full dmesg with

echo 1 > /sys/module/drm/parameters/debug

Dave.

>
> Dec 17 20:02:41 winchester [   43.741709] BUG: unable to handle kernel NULL
> pointer dereference at 0000000000000000
> Dec 17 20:02:41 winchester [   43.741723] IP: [<ffffffff8038411d>]
> radeon_cp_init+0x311/0x9f6
> Dec 17 20:02:41 winchester [   43.741740] PGD 4d501067 PUD 4d533067 PMD 0
> Dec 17 20:02:41 winchester [   43.741747] Oops: 0002 [#1]
> Dec 17 20:02:41 winchester [   43.741751] last sysfs file:
> /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0/resource
> Dec 17 20:02:41 winchester [   43.741757] CPU 0
> Dec 17 20:02:41 winchester [   43.741760] Modules linked in:
> Dec 17 20:02:41 winchester [   43.741766] Pid: 3630, comm: X Not tainted
> 2.6.28-rc8-next-20081217 #192
> Dec 17 20:02:41 winchester [   43.741771] RIP: 0010:[<ffffffff8038411d>]
>  [<ffffffff8038411d>] radeon_cp_init+0x311/0x9f6
> Dec 17 20:02:41 winchester [   43.741780] RSP: 0018:ffff88004d575e18
>  EFLAGS: 00010282
> Dec 17 20:02:41 winchester [   43.741784] RAX: ffff88004f36d640 RBX:
> ffff88004f257400 RCX: ffff88004f36d640
> Dec 17 20:02:41 winchester [   43.741789] RDX: 0000002000000002 RSI:
> ffff88004f3fd000 RDI: ffff88004f085800
> Dec 17 20:02:41 winchester [   43.741793] RBP: ffff88004d575e38 R08:
> ffff88004d559600 R09: ffff88004d575ef8
> Dec 17 20:02:41 winchester [   43.741798] R10: 0000000000000000 R11:
> 0000000000003202 R12: ffff88004f085800
> Dec 17 20:02:41 winchester [   43.741802] R13: ffff88004eb9d500 R14:
> 0000000000000000 R15: ffff88004eb9db00
> Dec 17 20:02:41 winchester [   43.741808] FS:  00007f845ffa26f0(0000)
> GS:ffffffff80699e40(0000) knlGS:0000000000000000
> Dec 17 20:02:41 winchester [   43.741813] CS:  0010 DS: 0000 ES: 0000 CR0:
> 000000008005003b
> Dec 17 20:02:41 winchester [   43.741817] CR2: 0000000000000000 CR3:
> 000000004d55f000 CR4: 00000000000006e0
> Dec 17 20:02:41 winchester [   43.741822] DR0: 0000000000000000 DR1:
> 0000000000000000 DR2: 0000000000000000
> Dec 17 20:02:41 winchester [   43.741826] DR3: 0000000000000000 DR6:
> 00000000ffff0ff0 DR7: 0000000000000400
> Dec 17 20:02:41 winchester [   43.741832] Process X (pid: 3630, threadinfo
> ffff88004d574000, task ffff88004f287330)
> Dec 17 20:02:41 winchester [   43.741835] Stack:
> Dec 17 20:02:41 winchester [   43.741838]  00000000fffffff4 0000000040786440
> ffff88004f085800 ffffffff80383e0c
> Dec 17 20:02:41 winchester [   43.741845]  ffff88004d575e98 ffffffff8037249e
> ffff88004d575e48 ffff88004d575e48
> Dec 17 20:02:41 winchester [   43.741852]  00007fff67fbf5a0 ffff88004eb9d500
> ffff88004f08583c ffff88004d559600
> Dec 17 20:02:41 winchester [   43.741860] Call Trace:
> Dec 17 20:02:41 winchester [   43.741865]  [<ffffffff80383e0c>] ?
> radeon_cp_init+0x0/0x9f6
> Dec 17 20:02:41 winchester [   43.741871]  [<ffffffff8037249e>]
> drm_ioctl+0x1de/0x270
> Dec 17 20:02:41 winchester [   43.741881]  [<ffffffff80298d2e>]
> vfs_ioctl+0x4a/0x55
> Dec 17 20:02:41 winchester [   43.741890]  [<ffffffff8029911a>]
> do_vfs_ioctl+0x3b2/0x3ff
> Dec 17 20:02:41 winchester [   43.741896]  [<ffffffff8028d0fa>] ?
> fsnotify_modify+0x4e/0x53
> Dec 17 20:02:41 winchester [   43.741904]  [<ffffffff802991ac>]
> sys_ioctl+0x45/0x80
> Dec 17 20:02:41 winchester [   43.741910]  [<ffffffff8028de98>] ?
> sys_write+0x62/0x72
> Dec 17 20:02:41 winchester [   43.741917]  [<ffffffff8020b94b>]
> system_call_fastpath+0x16/0x1b
> Dec 17 20:02:41 winchester [   43.741925] Code: 00 00 49 8b 45 60 48 89 83
> f8 00 00 00 49 8b 45 68 48 89 83 00 01 00 00 49 8b 45 70 48 89 83 08 01 00
> 00 e8 7e da fe ff 48 85 c0 <49> 89 06 48 c7 c6 b0 4e 4d 80 48 c7 c7 13 4a 5c
> 80 0f 84 a7 fd
> Dec 17 20:02:41 winchester [   43.741970] RIP  [<ffffffff8038411d>]
> radeon_cp_init+0x311/0x9f6
> Dec 17 20:02:41 winchester [   43.741977]  RSP <ffff88004d575e18>
> Dec 17 20:02:41 winchester [   43.741980] CR2: 0000000000000000
> Dec 17 20:02:41 winchester [   43.741984] ---[ end trace dc6d31ddec008340
> ]---
> Dec 17 20:02:41 winchester [   43.761235] [drm:drm_release] *ERROR* Device
> busy: 1
>
> What other information can I provide?
>
> --
> Kevin Winchester
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
