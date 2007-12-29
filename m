Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbXL2GDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbXL2GDC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 01:03:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbXL2GCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 01:02:52 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:46790 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbXL2GCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 01:02:51 -0500
Date: Fri, 28 Dec 2007 22:02:51 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: David Newall <david@davidnewall.com>, Mark Lord <lkml@rtr.ca>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
In-Reply-To: <Pine.LNX.4.64.0712290429350.29013@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.DEB.0.999999.0712282152190.5207@twinlark.arctic.org>
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca> <4768973C.8020909@davidnewall.com> <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org>
 <Pine.LNX.4.64.0712290429350.29013@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2007, Jan Engelhardt wrote:

> 
> On Dec 28 2007 18:53, dean gaudet wrote:
> >p.s. in retrospect i probably could have arranged it more like this:
> >
> >  mount /dev/md1 $tmpmntpoint
> >  mount --bind $tmpmntpoint/var /var
> >  mount --bind $tmpmntpoint/home /home
> >  umount $tmpmntpoint
> >
> >except i can't easily specify that in fstab... and neither of the bind 
> >mounts would show up in df(1).  seems like it wouldn't be hard to support 
> >this type of subtree mount though.  mount(8) could support a single 
> >subtree mount using this technique but the second subtree mount attempt 
> >would fail because you can't temporarily remount the device because the 
> >mount point is gone.
> 
> Why is it gone?
> 
> mount /dev/md1 /tmpmnt
> mount --bind /tmpmnt/var /var
> mount --bind /tmpmnt/home /home
> 
> Is perfectly fine, and /tmpmnt is still alive and mounted. Additionally,
> you can
> 
> umount /tmpmnt
> 
> now, which leaves only /var and /home.

i was trying to come up with a userland-only change in mount(8) which
would behave like so:

# mount --subtree var /dev/md1 /var
  internally mount does:
  - mount /dev/md1 /tmpmnt
  - mount --bind /tmpmnt/var /var
  - umount /tmpmnt

# mount --subtree home /dev/md1 /home
  internally mount does:
  - mount /dev/md1 /tmpmnt
  - mount --bind /tmpmnt/home /home
  - umount /tmpmnt

but that second mount would fail because /dev/md1 is already mounted
(but the mount point is gone)...

it certainly works if i issue the commands individually as i described
-- but a change within mount(8) would have the benefit of working with
/etc/fstab too.

-dean
