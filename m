Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbXIGVl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbXIGVl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 17:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbXIGVlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 17:41:19 -0400
Received: from smtp108.sbc.mail.re2.yahoo.com ([68.142.229.97]:48973 "HELO
	smtp108.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758595AbXIGVlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 17:41:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=SKJBbmMoMmr/Nd/AMX4UjG2v5cSOuagqoeCpemOn5rXTDFgpJYvwRB4rXYMdtkIBKYCL196q+8fItIqVqMBgKfksR3OIF2CoSQqqynffBpIBqTD8SH3ca6g7flvoBsQEOSvHE7cCj38OlAcDVOUkum3nEfTRkGlivp05Q5AMyHg=  ;
Date: Fri, 07 Sep 2007 14:41:15 -0700
From: David Brownell <david-b@pacbell.net>
To: hmh@hmh.eng.br
Subject: Re: Platform device id
Cc: linux-kernel@vger.kernel.org, khali@linux-fr.org, gregkh@suse.de,
       dmitry.torokhov@gmail.com
References: <20070907153559.17faf9d1@hyperion.delvare>
 <d120d5000709070758i1b54a37o3d3977304a84b2c1@mail.gmail.com>
 <20070907164129.65816B9389@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20070907210029.GB4357@khazad-dum.debian.net>
In-Reply-To: <20070907210029.GB4357@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070907214116.5051B237214@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > For that matter, a *driver* should never create its own device node(s)
> > in the first place.  Device creation belongs elsewhere, like as part of
> > platform setup or, for busses with integral enumeration support like
> > PCI or USB, bus glue.  Linux is moving away from that legacy model.
>
> This assumes that we have a better bus than "platform" to dump drivers like
> thinkpad-acpi, hdaps, and a host of other host-specific stuff.

I don't follow.  If it's host-specific, then it's easy enough to
have a host-specific routine creating those platform devices.
A different host wouldn't call that routine.

Embedded Linux platforms do that *ALL* the time.  ARM keys on a
board ID provided early in boot (e.g. by U-Boot).  PowerPC uses
a device tree, which ISTR evolved from the OpenBoot as first used
on SPARC.  Worst comes to worst, the kernel command line can say
which board is involved, and thus which setup code to run.

(Also, note that "platform", "host", and "board" are ambiguous.
In some contexts each is synonymous; in others, not.  I avoid
using "host" except in the protocol sense.  Usually "board" is
pretty specific -- this cpu, those peripherals -- although it
gets messy when the system is really a board stack, or when the
CPU may be socketed or be in a customizable FPGA etc.)


> > I realize that may be more easily said than done in some cases,
> > like i8042 on non-PNP systems.
>
> Yes, and there is a LOT of non-PNP stuff involved, since platform became the
> dumping ground for host-specific devices (as opposed to platform-specific
> devices).

See above ... most embedded systems aren't x86, so lack of PNP is
less of an issue than plain old legacy system designs -- designed
in ways that complicate or prevent probe/discovery schemes, which
gets to be a mess (like the one preceding PNP with DOS/x86/ISA).

Less clear cases include orphaned drivers, especially ones for
hardware that's on its way out or already obsolete.  Most folk
don't want to touch those, for fear of getting stuck to them.  :)

- Dave

