Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbYHCUJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbYHCUJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 16:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbYHCUJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 16:09:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:36863 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbYHCUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 16:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lMR8FwNyhbizHzW6j5tAhPOUfx+2ohu8zKq4+NAq64elWbqUfuCQDQXiO6eSiXt4Xz
         t78lOFREwKM4764M/O6ZHqgLII1bLBXkiDim5njWH509eP48E5is5MVZ/19az0Vpy+EW
         Iah6bibhjGdOrCABjw6LBo166t71gWgoC2ujw=
Message-ID: <58cb370e0808031309n54052c51m744c479aa69b2f4a@mail.gmail.com>
Date: Sun, 3 Aug 2008 22:09:25 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata) and IDE
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <1217779055.4179.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217779055.4179.10.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using gmail's interface (I don't have access to my laptop ATM) so
the mail may look a bit weird...

On Sun, Aug 3, 2008 at 5:57 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Right at the moment, we have two separate subsystems for running IDE
> type devices:  driver/ide and drivers/ata.  The claim I've seen is that
> drivers/ata can do everything drivers/ide can do plus it does sata.  I

This claim doesn't seem to have confirmation in facts:

* There is still hardware that is simply not-supported by libata at all:

  - architecture specific hardware (ppc, m68k, mips, arm)

  - "difficult" legacy PC-class hardware (i.e. secondary interface on
CY82C693 etc)

* There are still regressions in many libata PCI host drivers dating back
  to their rushed introduction.

* There are still corner case in libata core - PIO is dead slow
compared to drivers/ide/,
  "serialized" hosts are not supported, some quirks for obsolete
hardware got lost...

> also note that no major distribution seems to enable anything in
> drivers/ide anymore, so given this is it time to deprecate drivers/ide?

Major distributions make their own decisions (I don't remeber anybody from
these distros discussing the conversion on linux-kernel or linux-ide) which
sometimes don't match with what kernel.org kernels are doing.

[ Actually one distro went so far as CONFIG_IDE=n even before support for
  all PC-class IDE PCI hardware present in drivers/ide was available
in libata. ]

Also the same major distros that use libata on x86 are using
drivers/ide on non-x86.

> A counter argument to the above is that not all drivers (particularly
> the older ones where hw is scarce) are converted to drivers/ata, so
> drivers/ide seems to be needed for some legacy systems (in which case it
> can be deprecated but not removed).  I've also noted that some embedded
> distributions seem to be using drivers/ide, but I'm not really sure
> whether this is inertia or some overriding need.

drivers/ide deprecation would be a premature thing.

> The proposal is to discuss the future of these two subsystems and arrive
> at a consensus what's happening to each going forwards.

Well, I'm looking forward to discuss the future of Linux ATA support.

Thanks,
Bart
