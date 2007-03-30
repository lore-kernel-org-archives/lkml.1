Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXC3WPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXC3WPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932658AbXC3WPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:15:41 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58211 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbXC3WPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:15:40 -0400
X-Originating-Ip: 74.109.98.130
Date: Fri, 30 Mar 2007 18:15:04 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Jan Glauber <jang@linux.vnet.ibm.com>
cc: Thomas Backlund <tmb@mandriva.org>, linux-kernel@vger.kernel.org
Subject: Re: Why is arch/s390/crypto/Kconfig sourced when building for another
 arch ?
In-Reply-To: <1175271610.5474.30.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0703301810160.19277@CPE00045a9c397f-CM001225dbafb6>
References: <eueg41$j5t$1@sea.gmane.org>  <1175247012.5474.15.camel@localhost.localdomain>
  <Pine.LNX.4.64.0703300551460.10946@CPE00045a9c397f-CM001225dbafb6>
 <1175271610.5474.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Jan Glauber wrote:

> On Fri, 2007-03-30 at 05:55 -0400, Robert P. J. Day wrote:
> >   i'm betting the S390 folks would *really* hate that idea but, if you
> > look closely, the generic Kconfig file *already* has some
> > arch-dependent content:
> >
> > ...
> > config CRYPTO_DEV_PADLOCK
> >         tristate "Support for VIA PadLock ACE"
> >         depends on X86_32     <-----
> > ...
>
> Yes, but the padlock driver is located under drivers/crypto. The
> s390 crypto stuff is not. It is under arch/s390/crypto, thats why
> the Kconfig file is there...

  which differs from the way it's handled with x86_64.  even though
the actual crypto routines specific to x86_64 are in
arch/x86_64/crypto (as they are with s390), the menuconfig selections
for them are defined in the *generic* crypto/Kconfig file:

...
config CRYPTO_TWOFISH_X86_64
        tristate "Twofish cipher algorithm (x86_64)"
        depends on (X86 || UML_X86) && 64BIT
        select CRYPTO_ALGAPI
        select CRYPTO_TWOFISH_COMMON
        help
          Twofish cipher algorithm (x86_64).

          Twofish was submitted as an AES (Advanced Encryption Standard)
          candidate cipher by researchers at CounterPane Systems.  It is a
          16 round block cipher supporting key sizes of 128, 192, and 256
          bits.

          See also:
          <http://www.schneier.com/twofish.html>
...


  a little consistency would be nice.  :-)

rday

