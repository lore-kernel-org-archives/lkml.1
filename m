Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbXJVQ5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbXJVQ5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 12:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbXJVQ5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 12:57:09 -0400
Received: from twin.jikos.cz ([213.151.79.26]:56056 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbXJVQ5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 12:57:08 -0400
Date: Mon, 22 Oct 2007 18:57:04 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Esben Stien <b0ef@esben-stien.name>
cc: linux-kernel@vger.kernel.org
Subject: Re: USB Disconnect BUG with RT Kernels (linux-2.6.23-rt1)
In-Reply-To: <87640zgid6.fsf@esben-stien.name>
Message-ID: <Pine.LNX.4.64.0710221855220.18815@twin.jikos.cz>
References: <87640zgid6.fsf@esben-stien.name>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, Esben Stien wrote:

>  [<c0319a64>] input_unregister_device+0x67/0xfc
>  [<c032a139>] hidinput_disconnect+0x2e/0x47
>  [<c032d697>] hid_disconnect+0x76/0xce
>  [<c02fd799>] usb_unbind_interface+0x2d/0x6e
>  [<c02b7ba4>] __device_release_driver+0x71/0x8e
>  [<c02b7c65>] device_release_driver+0x18/0x21
>  [<c02b76f3>] bus_remove_device+0x70/0x80
>  [<c02b5ddf>] device_del+0x1bb/0x22f
>  [<c02fb4f1>] usb_disable_device+0x5c/0xbb
>  [<c02f807d>] usb_disconnect+0x7a/0xd3
>  [<c02f85a9>] hub_thread+0x30f/0x9ea
>  [<c010d79a>] update_stats_wait_end+0x9b/0xbe
>  [<c03c4c32>] __schedule+0x27e/0x36d
>  [<c01214e5>] autoremove_wake_function+0x0/0x35
>  [<c02f829a>] hub_thread+0x0/0x9ea
>  [<c012142e>] kthread+0x36/0x5c
>  [<c01213f8>] kthread+0x0/0x5c
>  [<c0102913>] kernel_thread_helper+0x7/0x10
>  =======================
> Code: e8 3c c5 ff ff 8b 5e 64 eb 1b 8d 83 08 04 00 00 b9 06 00 02 00 ba 1d 00 00 00 e8 d7 fc e3 ff 8b 9b 10 04 00 00 81 eb 10 04 00 00 <8b> 83 10 04 00 00 0f 18 00 90 8d 93 10 04 00 00 8d 46 64 39 c2 
> EIP: [<c031c3d9>] evdev_disconnect+0x5b/0x96 SS:ESP 0068:c1e07e84

Please try the latest git. Dmitry has pushed patches that implement proper 
locking in input layer, which are very likely going to fix the bug you are 
seeing.

Namely commits 8006479, 6addb1d and 464b241, so please try to reproduce 
with any kernel that has them.

Thanks,

-- 
Jiri Kosina
