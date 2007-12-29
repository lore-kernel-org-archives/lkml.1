Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXL2Gsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXL2Gsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 01:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbXL2Gs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 01:48:28 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33221 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbXL2Gs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 01:48:27 -0500
Date: Sat, 29 Dec 2007 07:48:25 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: dean gaudet <dean@arctic.org>
cc: David Newall <david@davidnewall.com>, Mark Lord <lkml@rtr.ca>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
In-Reply-To: <alpine.DEB.0.999999.0712282152190.5207@twinlark.arctic.org>
Message-ID: <Pine.LNX.4.64.0712290747260.23321@fbirervta.pbzchgretzou.qr>
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk>
 <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca>
 <4768973C.8020909@davidnewall.com> <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org>
 <Pine.LNX.4.64.0712290429350.29013@fbirervta.pbzchgretzou.qr>
 <alpine.DEB.0.999999.0712282152190.5207@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 28 2007 22:02, dean gaudet wrote:
>
>i was trying to come up with a userland-only change in mount(8) which
>would behave like so:
>
># mount --subtree var /dev/md1 /var
>  internally mount does:
>  - mount /dev/md1 /tmpmnt
>  - mount --bind /tmpmnt/var /var
>  - umount /tmpmnt
>
># mount --subtree home /dev/md1 /home
>  internally mount does:
>  - mount /dev/md1 /tmpmnt
>  - mount --bind /tmpmnt/home /home
>  - umount /tmpmnt
>
>but that second mount would fail because /dev/md1 is already mounted
>(but the mount point is gone)...

I do not think it would fail. Like this:

# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/home     208486056 158605472  49880584  77% /home
# mount /dev/mapper/home /mnt
# df
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/home     208486056 158605472  49880584  77% /home
/dev/mapper/home     208486056 158605472  49880584  77% /mnt

