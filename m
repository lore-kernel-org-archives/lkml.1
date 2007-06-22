Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbXFVOqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbXFVOqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbXFVOqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:46:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39208 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXFVOqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:46:11 -0400
Subject: Re: JIT emulator needs
From: Arjan van de Ven <arjan@infradead.org>
To: Albert Cahalan <acahalan@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <787b0d920706220732hef20f67h6b5d1d57db71ead2@mail.gmail.com>
References: <787b0d920706072335v10d6025cwe1437194b6c60d84@mail.gmail.com>
	 <1182447884.2704.7.camel@laptopd505.fenrus.org>
	 <787b0d920706212256u7e78ba6n15ef41bcea99aff0@mail.gmail.com>
	 <1182519821.2672.1.camel@laptopd505.fenrus.org>
	 <787b0d920706220732hef20f67h6b5d1d57db71ead2@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 22 Jun 2007 07:42:11 -0700
Message-Id: <1182523332.2672.14.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > and these methods also destroy yourself on any machine with a looser
> > > > cache coherency between I and D-cache....
> > > >
> > > > for all but x86 you pretty much have to do the mprotect() between the
> > > > two states to deal with the cache flushing properly...
> > >
> > > If the instructions to force data write-back and/or to
> > > invalidate the instruction cache are priveleged, yes.
> > > AFAIK, only ARM is that lame.
> >
> > and your program executes this on all the cpus in the system?

no I meant that you had to call your userspace instruction on all cpus,
so on all-but-arm (from the Intel side I know IA64 needs such a flush,
but I'm pretty sure PPC does too)


> I don't recall seeing such code in the libgcc tranpoline
> setup for PowerPC. Either it's not required, or this is
> a rather popular bug.

I suspect it'll be playing under the assumption that going from "no
code" to "code" is fine since the icache is cold.


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

