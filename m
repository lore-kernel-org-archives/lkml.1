Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbYG2VUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbYG2VUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 17:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYG2VUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 17:20:09 -0400
Received: from sov-mail-b0023.gradwell.net ([193.84.87.47]:42676 "EHLO
	sov-mail-b0023.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753424AbYG2VUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 17:20:08 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2008 17:20:07 EDT
Date: Tue, 29 Jul 2008 22:09:08 +0100
From: Alex Buell <alex.buell@munted.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Tomas Styblo <tripie@cpan.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] JMicron JM20337 USB-SATA data corruption bugfix -
 device 152d:2338
Message-Id: <20080729220908.8b698469.alex.buell@munted.org.uk>
In-Reply-To: <48859E2C.4070805@shaw.ca>
References: <fa.eWQqoO1e4Mdhu8SK5jzMFAI/3NU@ifi.uio.no>
	<4884E585.2050104@shaw.ca>
	<20080722051110.GA8303@notebook.homenet.local>
	<488570A5.8000602@shaw.ca>
	<20080722061147.GB8303@notebook.homenet.local>
	<48859E2C.4070805@shaw.ca>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 02:45:32 -0600, I waved a wand and this message
magically appears in front of Robert Hancock:

> I suppose it wouldn't hurt to let JMicron know about this. I doubt
> they could do anything for existing chipsets, but it might help them
> avoid this bug in future designs.

I can reproduce this EVERY time with SATA disks using the same JM20337
chipset. 

1. mke2fs /dev/sda1
2. tunefs -j /dev/sda1
3. e2fsck /dev/sda1

This spits out a whole load of:
Jul 29 22:04:41 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:04:41 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:04:43 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:04:43 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:04:44 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:04:44 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:04:45 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:04:45 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:04:45 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:04:45 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:06:31 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:06:31 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:06:32 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:06:32 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:06:35 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:06:35 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:06:51 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:06:51 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:06:51 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:06:51 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:06:54 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:06:54 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:07:37 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:07:37 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:07:37 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:07:37 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:07:47 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:07:47 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:08:04 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:08:04 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0
Jul 29 22:08:06 lithium sd 4:0:0:0: [sda] Sense Key : 0x0 [current] 
Jul 29 22:08:06 lithium sd 4:0:0:0: [sda] ASC=0x0 ASCQ=0x0

-- 
http://www.munted.org.uk

Fearsome grindings.
