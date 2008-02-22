Return-Path: <linux-kernel-owner+w=401wt.eu-S1764884AbYBVJkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764884AbYBVJkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbYBVJkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:40:09 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54238 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752387AbYBVJkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:40:07 -0500
Date: Fri, 22 Feb 2008 09:28:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Joel Becker <Joel.Becker@oracle.com>, Jody Belka <lists-lkml@pimb.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080222092855.6ace8845@core>
In-Reply-To: <1203665106.28436.19.camel@cthulhu.hellion.org.uk>
References: <20080212235404.GY7980@pimb.org>
	<47B2DBA5.6030001@goop.org>
	<20080214022744.GA4160@mail.oracle.com>
	<47B3F2DC.8080707@goop.org>
	<20080215202336.GE26034@mail.oracle.com>
	<1203274161.27987.6.camel@localhost.localdomain>
	<20080218104025.GA15899@ca-server1.us.oracle.com>
	<1203458366.26910.15.camel@cthulhu.hellion.org.uk>
	<47BBDA20.8030105@zytor.com>
	<1203497511.26910.39.camel@cthulhu.hellion.org.uk>
	<47BCA275.7000504@goop.org>
	<1203546597.26910.74.camel@cthulhu.hellion.org.uk>
	<47BDEA11.6010302@goop.org>
	<47BDEB57.5040203@zytor.com>
	<47BDEF36.8000903@goop.org>
	<1203631956.28436.4.camel@cthulhu.hellion.org.uk>
	<47BDF9C7.6040400@zytor.com>
	<47BE0017.1020205@goop.org>
	<47BE0228.7020204@zytor.com>
	<1203665106.28436.19.camel@cthulhu.hellion.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd been meaning to ask this. So the machines you have which don't
> describe 0xf0000 as reserved also don't describe it as RAM? (I guess
> it's either a hole in the table or one of the other e820 types).

Making 0xf0000 bus addresses RAM is probably a bad idea anyway. Most OS's
treat the E820 map with paranoia because we do see real PCs which
variously claim that the BIOS ROM space is RAM, ACPI, Reserved or just
forget to mention it. At least for a non PV guest it should be mapped as
R/O.

Likewise you get E820 maps with zero size entries, repeated entries ...

