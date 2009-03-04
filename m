Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZCDKTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZCDKTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZCDKTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:19:36 -0500
Received: from sov-mail-b0012.gradwell.net ([193.84.87.36]:43067 "EHLO
	sov-mail-b0012.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbZCDKTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:19:36 -0500
Date: Wed, 4 Mar 2009 10:19:29 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Ramdisk driver module
Message-ID: <20090304101929.62bba811@lithium.local.net>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

I've just put together a ramdisk driver module over the last few days
adapted from bits that I've gleaned on the 'net. However, I have found
a problem with the module that I've not been able to solve yet. When
loading it for the first time, it all works perfectly, I can create a
filesystem on the devices, copy files onto it, then unload it
perfectly. 

The problem arises when I reload the module, it crashes with 'badness
at fs/sysfs/dir.c:463' on my G3 iMac PPC machine which I use as a
generic kernel development machine, this runs 2.6.27.

There's this line: 
'kobject_add_internal failed for 252:0 with -EEXIST, don't try to
register things with the same name in the same directory.'

252:0 is the dynamically assigned device major-minor number which is
correct. The odd thing when looking over the code in unload.c where it
unregisters the device it appears to work just fine. And I look at
the /dev/* directory and the device name definitely disappears when
unloaded. Yet when I reload the module it crashes with the above error. 

Any ideas why? I've bzipped up the sources and uploaded it to
http://www.munted.org.uk/programming/ramdisk.tar.bz2

Also, I'd appreciate some constructive advice on improving on my work
further. 

The original reason why I wrote this ramdisk was that I intended to use
variable sector sizes with it so I could test filesystems with it, as I
see that devices with 4k sectors could be on the market soon.

Thanks
Alex
-- 
http://www.munted.org.uk

Fearsome grindings.
