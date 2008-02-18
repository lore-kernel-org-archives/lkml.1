Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbYBRXBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbYBRXBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbYBRXBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:01:14 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34323 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbYBRXBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:01:13 -0500
Date: Mon, 18 Feb 2008 23:00:58 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Michael Buesch <mb@bu3sch.de>
Cc: Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Message-ID: <20080218230058.GA32357@flint.arm.linux.org.uk>
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <200802182324.45267.mb@bu3sch.de> <20080218223410.GD23181@flint.arm.linux.org.uk> <200802182343.12749.mb@bu3sch.de> <20080218225354.GE23181@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080218225354.GE23181@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 10:53:54PM +0000, Russell King wrote:
> On Mon, Feb 18, 2008 at 11:43:12PM +0100, Michael Buesch wrote:
> > On Monday 18 February 2008 23:34:10 Russell King wrote:
> > > On Mon, Feb 18, 2008 at 11:24:44PM +0100, Michael Buesch wrote:
> > > > On Monday 18 February 2008 23:13:24 Russell King wrote:
> > > > > On Mon, Feb 18, 2008 at 11:08:56PM +0100, Michael Buesch wrote:
> > > > > > On Monday 18 February 2008 23:03:10 Gordon Farquharson wrote:
> > > > > > > The b43 driver in 2.6.25-rc[12] fails to build for arm on an x86_64
> > > > > > > box using a cross-compiler:
> > > > > > > 
> > > > > > > FATAL: drivers/net/wireless/b43/b43: sizeof(struct ssb_device_id)=6 is
> > > > > > > not a modulo of the size of section __mod_ssb_device_table=64.
> > > > > > > Fix definition of struct ssb_device_id in mod_devicetable.h
> > > > > > 
> > > > > > Why does ARM have this special requirement and what is it about?
> > > > > 
> > > > > Because ARM is a 32 bit architecture.
> > > > 
> > > > Ehm, I didn't see this warning on any other architecture nor did we
> > > > have _any_ problem with it on any other architecture.
> > > > This code runs fine on x86_32, x86_64, powerpc and mips, at least.
> > > 
> > > Well, don't expect this driver to work until you fix your broken
> > > assumptions about alignment requirements.
> > 
> > Mr King, I'm not an idiot!
> 
> I get extremely pissed off everytime I have to try to explain random
> alignment issues to people.  "It doesn't work like i386 so it must be
> broken" is a rediculous position to take.
> 
> > Can you _please_ explain what makes ARM so special here?
> 
> No because I don't really know.
> 
> > Why can't we have an array of this structure on ARM?
> > 
> > struct ssb_device_id {
> >        __u16   vendor;
> 
> 2 bytes
> 
> >        __u16   coreid;
> 
> 2 bytes
> 
> >        __u8    revision;
> 
> 1 byte
> 
> > };
> 
> and therefore sizeof this structure will be 5 bytes, but because of the
> ABI rules (which are _explicitly_ allowed by the C standard), it'll
> become 8 bytes due to padding afterwards.

Another guess might be that, if using AEABI, this structure might
be 6 bytes in size, but the linker will align structures to 4 bytes.

As I say, this is all guess work.  I don't know for sure.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
