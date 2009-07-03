Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZGCBLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZGCBLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZGCBLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:11:42 -0400
Received: from mail.samba.org ([66.70.73.150]:50014 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbZGCBLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:11:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19021.23231.213863.726785@samba.org>
Date: Fri, 3 Jul 2009 11:11:27 +1000
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <87hbxu60qm.fsf@devron.myhome.or.jp>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
	<alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr>
	<19021.19842.663727.146474@samba.org>
	<87hbxu60qm.fsf@devron.myhome.or.jp>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I have no objection to improve. And in this case, for this option, to
 > force the shortname= sounds reasonable.

Great! 

Which varient of this would you prefer I implement? I think the two
obvious choices are:

 1) do what I did in the May patch, which is to force
    VFAT_SFN_CREATE_WINNT when the patch code triggers.

 2) force VFAT_SFN_CREATE_WINNT, but also if the name is mixed case
 within either prefix or extension (such as "Mixed.TXT") then force
 that part of the name to all lowercase. So "Mixed.TXT" would become
 "mixed.TXT" on disk.

The 2nd choice maximises compatibility with devices that don't
understand long filenames (such as Jan's camera). The first option
keeps case preservation for devices that do understand long filenames.

What do you think?

Cheers, Tridge
