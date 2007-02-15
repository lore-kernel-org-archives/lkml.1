Return-Path: <linux-kernel-owner+w=401wt.eu-S964786AbXBNXbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786AbXBNXbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbXBNXbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:31:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45055 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751376AbXBNXbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:31:03 -0500
Date: Thu, 15 Feb 2007 00:33:39 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
Message-ID: <20070215003339.1420faff@localhost.localdomain>
In-Reply-To: <45D384C4.2000306@vmware.com>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
	<20070206122729.GC47229@muc.de>
	<45C8FA2D.6010706@vmware.com>
	<20070207123552.GD4481@ucw.cz>
	<1170880572.11736.4.camel@localhost.localdomain>
	<20070214125216.2befda78@localhost.localdomain>
	<45D36B49.5090109@vmware.com>
	<20070214213423.4834941b@localhost.localdomain>
	<45D384C4.2000306@vmware.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 13:53:08 -0800
Zachary Amsden <zach@vmware.com> wrote:

> > IDE on several platforms has performance critical paths that use
> > ndelay(400) or failing that udelay(1)
> 
> Ok, I buy that.  A 486DX / 33 Mhz processor takes 10 cycles to issue a 
> CALL / RET pair.  This is about 300ns.  Is there an issue with being too 
> early to issue I/O operations or too late?

Too early you lose, too late you just waste clock time.

> But I fail to see how such careful timing can be done at this 
> granularity on such hardware without well tweaked assembly code. 

Thats what is used  most platforms use udelay(1) in fact however
