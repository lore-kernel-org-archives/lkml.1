Return-Path: <linux-kernel-owner+w=401wt.eu-S1758058AbXGBW7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058AbXGBW7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbXGBW7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:59:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756002AbXGBW7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:59:36 -0400
Date: Mon, 2 Jul 2007 15:59:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ni@m" <niam.niam@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net
Subject: Re: NIKON D50 problem
Message-Id: <20070702155912.fe1e6834.akpm@linux-foundation.org>
In-Reply-To: <a9e22dff0707021217r239ebcf0g8154a6e985b078f3@mail.gmail.com>
References: <a9e22dff0707021217r239ebcf0g8154a6e985b078f3@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007 22:17:20 +0300
"Ni@m" <niam.niam@gmail.com> wrote:

> Hi! Recently I've found out that my camera NIKON D50 can't mount any more.
> uname -a: "Linux niam 2.6.22-rc6-cfs-v18 #6 Mon Jul 2 20:19:25 EEST
> 2007 i686 Intel(R) Celeron(R) M processor 1.50GHz GenuineIntel
> GNU/Linux"
> 
> dmesg:
> scsi 2:0:0:0: Direct-Access     NIKON    D50              1.00 PQ: 0 ANSI: 2
> sd 2:0:0:0: [sdb] 1984001 512-byte hardware sectors (1016 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 0f 00 00 00
> sd 2:0:0:0: [sdb] Assuming drive cache: write through
> sd 2:0:0:0: [sdb] 1984001 512-byte hardware sectors (1016 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 0f 00 00 00
> sd 2:0:0:0: [sdb] Assuming drive cache: write through
>  sdb: sdb1
> sd 2:0:0:0: [sdb] Attached SCSI removable disk
> sd 2:0:0:0: Attached scsi generic sg2 type 0
> usb-storage: device scan complete
> end_request: I/O error, dev sdb, sector 1984000
> Buffer I/O error on device sdb, logical block 1984000
> end_request: I/O error, dev sdb, sector 1984000
> Buffer I/O error on device sdb, logical block 1984000
> end_request: I/O error, dev sdb, sector 1983992
> Buffer I/O error on device sdb, logical block 1983992
> end_request: I/O error, dev sdb, sector 1983993
> Buffer I/O error on device sdb, logical block 1983993
> Buffer I/O error on device sdb, logical block 1983994
> Buffer I/O error on device sdb, logical block 1983995
> Buffer I/O error on device sdb, logical block 1983996
> Buffer I/O error on device sdb, logical block 1983997
> Buffer I/O error on device sdb, logical block 1983998
> Buffer I/O error on device sdb, logical block 1983999
> end_request: I/O error, dev sdb, sector 1983992
> ...................
> 
> Some time ago(I really can't remember version of the kernel)
> everything was Ok. I'll try to find out the workable version of the
> kernel ... but I've already tried 2.6.20 - the same =(.
> I'm not sure, but It's possible that I've had ATA subsystem but not
> libata ... I haven't tested this case yet.
> 
> PS. I can see photos on my camera ... flash card is Ok. I have this
> problem even if I changed the flash card in this camera.

It's more likely a usb-storage or scsi layer problem.

The device reports as having 1984001 sectors and the kernel is reporting IO
errors around the very end of the device.  Presumably an IO is straddling
end-of-device and we're not handling that correctly.



