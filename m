Return-Path: <linux-kernel-owner+w=401wt.eu-S932228AbXBNMjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbXBNMjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 07:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932230AbXBNMjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 07:39:33 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44125 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932228AbXBNMjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 07:39:33 -0500
Date: Wed, 14 Feb 2007 12:52:16 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pavel Machek <pavel@ucw.cz>, Zachary Amsden <zach@vmware.com>,
       Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
Message-ID: <20070214125216.2befda78@localhost.localdomain>
In-Reply-To: <1170880572.11736.4.camel@localhost.localdomain>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
	<20070206122729.GC47229@muc.de>
	<45C8FA2D.6010706@vmware.com>
	<20070207123552.GD4481@ucw.cz>
	<1170880572.11736.4.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We'd have to audit and figure out what udelays are for hardware and
> which are not, but the evidence is that the vast majority of them are
> for hardware and not needed for virtualization.

Which is irrelevant since the hardware drivers won't be used in a
virtualised environment with any kind of performance optimisation.

> Changing udelay to "hardware_udelay" or something all over the kernel
> would have delayed the paravirt_ops merge by an infinite amount 8)

paravirt_ops has no business fiddling with udelay. Not only does it
create more code bloat and stalls in relatively fast paths but its
optimising the wrong thing anyway.

My performance sucks -> optimise out udelay is the wrong approach. My
performance sucks, switch to the virtual block driver is the right
approach, and a virtual block driver won't be using udelay anyway

Alan
