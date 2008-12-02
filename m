Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYLBGzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYLBGzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 01:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYLBGza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 01:55:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40258
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751222AbYLBGz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 01:55:29 -0500
Date: Mon, 01 Dec 2008 22:55:29 -0800 (PST)
Message-Id: <20081201.225529.137617862.davem@davemloft.net>
To: jengelh@medozas.de
Cc: john.haxby@oracle.com, netfilter-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: sg_set_page not usable for .bss?
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.1.10.0812020237520.23359@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0812020112480.19492@fbirervta.pbzchgretzou.qr>
	<20081201.161418.51389602.davem@davemloft.net>
	<alpine.LNX.1.10.0812020237520.23359@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>
Date: Tue, 2 Dec 2008 02:41:02 +0100 (CET)

> 
> On Tuesday 2008-12-02 01:14, David Miller wrote:
> >> >> 
> >> >> Well, sysrq_password is in the .bss section, where as digest_password
> >> >> is on the heap due to being kmalloc'ed. Maybe that makes a difference?
> >> >> Someone more versed with the virtual memory layer might know.
> >> >
> >> >You can't use these interfaces on kernel image addresses.
> >> >
> >> Great :-)  So what is the best way to use the SHA1 crypto algo
> >> with in-kernel addresses?
> >
> >kmalloc and copy it there, or something like that, you just
> >can't use in-kernel addresses, ever.
> >
> Yes, kmalloc is already used. But then, what sort of address
> does kmalloc return, if not an address within kernelspace?
> (usually >=0xc0000000 on standard i386)

I said "kernel image" addresses are a problem, not "kernel space."

And by "kernel image" I mean addresses within the confines defined
by the sections of the vmlinux binary.
