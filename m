Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbXGWFKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbXGWFKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 01:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXGWFJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 01:09:57 -0400
Received: from ozlabs.org ([203.10.76.45]:47615 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbXGWFJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 01:09:56 -0400
Subject: Re: [PATCH] Move KVM, paravirt, lguest, VMI and Xen under
	arch-level Virtualization option
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Avi Kivity <avi@qumranet.com>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707211748320.21737@fbirervta.pbzchgretzou.qr>
References: <1184905342.10380.263.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0707211748320.21737@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 15:09:31 +1000
Message-Id: <1185167371.6344.135.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-21 at 17:49 +0200, Jan Engelhardt wrote:
> On Jul 20 2007 14:22, Rusty Russell wrote:
> >Subject: [PATCH] Move KVM, paravirt, lguest,
> >    VMI and Xen under arch-level Virtualization option
> >
> >Any objections?
> 
> Well btw, would it make sense to also rearrange the directory structure along
> with it, i.e.
> 
> drivers/kvm    => drivers/virt/kvm
> drivers/lguest => drivers/virt/lguest
> drivers/xen    => drivers/virt/xen
> 
> Then the full kconfig (with menuconfig,if,endif) can go to
> drivers/virt/Kconfig.

It would reduce clutter a little, but it'll never cover cases where the
arch is always virtualized.  You could move VMI there, but UML, PowerPC,
S/390 won't be moving.

I still think people expect virtualization under CPU features, so archs
should include the virt Kconfig explicitly there (rather than it just
appearing deep in drivers/).  At which point cut & pasting variations of
the CONFIG_VIRTUALIZATION option is probably as good as any other
solution, and far less work.

Cheers,
Rusty.

