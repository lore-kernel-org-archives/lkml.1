Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbXL2Dbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbXL2Dbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 22:31:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXL2Dbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 22:31:31 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:42131 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbXL2Dbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 22:31:31 -0500
Date: Sat, 29 Dec 2007 04:31:28 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: dean gaudet <dean@arctic.org>
cc: David Newall <david@davidnewall.com>, Mark Lord <lkml@rtr.ca>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
In-Reply-To: <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org>
Message-ID: <Pine.LNX.4.64.0712290429350.29013@fbirervta.pbzchgretzou.qr>
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk>
 <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca>
 <4768973C.8020909@davidnewall.com> <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 28 2007 18:53, dean gaudet wrote:
>p.s. in retrospect i probably could have arranged it more like this:
>
>  mount /dev/md1 $tmpmntpoint
>  mount --bind $tmpmntpoint/var /var
>  mount --bind $tmpmntpoint/home /home
>  umount $tmpmntpoint
>
>except i can't easily specify that in fstab... and neither of the bind 
>mounts would show up in df(1).  seems like it wouldn't be hard to support 
>this type of subtree mount though.  mount(8) could support a single 
>subtree mount using this technique but the second subtree mount attempt 
>would fail because you can't temporarily remount the device because the 
>mount point is gone.

Why is it gone?

mount /dev/md1 /tmpmnt
mount --bind /tmpmnt/var /var
mount --bind /tmpmnt/home /home

Is perfectly fine, and /tmpmnt is still alive and mounted. Additionally,
you can

umount /tmpmnt

now, which leaves only /var and /home.
