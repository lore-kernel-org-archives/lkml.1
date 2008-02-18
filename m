Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbYBRXmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbYBRXmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYBRXmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:42:06 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52679 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbYBRXmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:42:05 -0500
Date: Tue, 19 Feb 2008 00:42:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Gordon Farquharson <gordonfarquharson@gmail.com>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Message-ID: <20080218234212.GA25680@uranus.ravnborg.org>
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com> <20080218225354.GE23181@flint.arm.linux.org.uk> <20080218230058.GA32357@flint.arm.linux.org.uk> <200802190017.04432.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802190017.04432.mb@bu3sch.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 12:17:04AM +0100, Michael Buesch wrote:
> On Tuesday 19 February 2008 00:00:58 Russell King wrote:
> > > > Why can't we have an array of this structure on ARM?
> > > > 
> > > > struct ssb_device_id {
> > > >        __u16   vendor;
> > > 
> > > 2 bytes
> > > 
> > > >        __u16   coreid;
> > > 
> > > 2 bytes
> > > 
> > > >        __u8    revision;
> > > 
> > > 1 byte
> > > 
> > > > };
> > > 
> > > and therefore sizeof this structure will be 5 bytes, but because of the
> > > ABI rules (which are _explicitly_ allowed by the C standard), it'll
> > > become 8 bytes due to padding afterwards.
> > 
> > Another guess might be that, if using AEABI, this structure might
> > be 6 bytes in size, but the linker will align structures to 4 bytes.
> 
> If the struct is padded to 6 bytes and the linker aligns it to 4 byte
> everything will be naturally aligned, as far as I can see.
> 
> > FATAL: drivers/net/wireless/b43/b43: sizeof(struct ssb_device_id)=6 is
> > not a modulo of the size of section __mod_ssb_device_table=64.
> > Fix definition of struct ssb_device_id in mod_devicetable.h
> 
> So this message tells me the table size is 64 bytes. There are 8 entries,
> so it seems the structure is padded to 8 bytes.
> But above that it says that sizeof(struct ssb_device_id)=6
> 
> IMO this sanity check is broken and not the code.
> 
> Where does this sanity check message come from? The linker?
$ git grep 'not a modulo'
scripts/mod/file2alias.c:               fatal("%s: sizeof(struct %s_device_id)=%lu is not a modulo "

It is a consistencycheck between host and target
layout of data.
You need to pad the structure so it becomes 8 byte in size.

	Sam
