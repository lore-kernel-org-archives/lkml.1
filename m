Return-Path: <linux-kernel-owner+w=401wt.eu-S1760501AbYHHUtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501AbYHHUtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 16:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYHHUtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 16:49:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42476 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509AbYHHUtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 16:49:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Neil Schemenauer <nas@arctrix.com>
Subject: Re: Hung task while reading USB mass storage device (2.6.26)
Date: Fri, 8 Aug 2008 22:51:54 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org
References: <20080808030025.GA18962@arctrix.com>
In-Reply-To: <20080808030025.GA18962@arctrix.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808082251.55394.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding CCs]

On Friday, 8 of August 2008, Neil Schemenauer wrote:
> Hi,
> 
> This happened with 2.6.26 on an AMD64 machine.  I was attempting to
> read an entire partition on a SD card attached to a USB reader.
> sysreq-W gives:
> 
> dd            D ffff8100010018b8     0  3887   3876
>  ffff810062a9dac8 0000000000000046 ffff81002f9ee420 ffff810054f80c28
>  ffffffff8047f8c0 ffff810062a9da78 ffff810062a9db58 ffffffff805d4f00
>  ffffffff805d4f00 ffffffff805d2270 ffffffff805d4f00 ffff81006e2106d0
> Call Trace:
>  [<ffffffff8025403b>] find_get_pages_tag+0x34/0x7e
>  [<ffffffff80254200>] sync_page+0x0/0x41
>  [<ffffffff8045aaab>] io_schedule+0x28/0x33
>  [<ffffffff8025423c>] sync_page+0x3c/0x41
>  [<ffffffff8045abf0>] __wait_on_bit_lock+0x3f/0x72
>  [<ffffffff802541ec>] __lock_page+0x5e/0x64
>  [<ffffffff8023ef3e>] wake_bit_function+0x0/0x23
>  [<ffffffff8025b884>] pagevec_lookup+0x17/0x1e
>  [<ffffffff8025bfae>] truncate_inode_pages_range+0x251/0x2d9
>  [<ffffffff80296c79>] __blkdev_put+0x4f/0x11c
>  [<ffffffff80274a77>] __fput+0xb1/0x176
>  [<ffffffff802723cb>] filp_close+0x5d/0x65
>  [<ffffffff8022ff6c>] put_files_struct+0x66/0xc4
>  [<ffffffff802311f7>] do_exit+0x23a/0x639
>  [<ffffffff8023745e>] __dequeue_signal+0x19/0x15a
>  [<ffffffff8023165c>] do_group_exit+0x66/0x93
>  [<ffffffff802392d8>] get_signal_to_deliver+0x2d5/0x2f2
>  [<ffffffff8020b1a7>] do_notify_resume+0xac/0x7d3
>  [<ffffffff8023ef10>] autoremove_wake_function+0x0/0x2e
>  [<ffffffff802743f4>] vfs_read+0x11e/0x132
>  [<ffffffff80274e18>] fget_light+0x19/0x8a
>  [<ffffffff8020be54>] sysret_signal+0x1c/0x27
>  [<ffffffff8020c0d7>] ptregscall_common+0x67/0xb0
> 
> I hope this information is useful.
> 
>   Neil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


