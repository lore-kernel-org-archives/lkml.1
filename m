Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbXKUJFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbXKUJFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 04:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758509AbXKUJEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 04:04:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55129 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759148AbXKUJEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 04:04:30 -0500
Date: Wed, 21 Nov 2007 01:04:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Avi Kivity <avi@qumranet.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
Message-Id: <20071121010409.27fbbc56.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711210350050.10132@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4743EB52.1040205@linux.vnet.ibm.com>
	<20071120163240.e54beed6.akpm@linux-foundation.org>
	<4743EF47.5000203@linux.vnet.ibm.com>
	<4743EFF8.9010307@qumranet.com>
	<alpine.LFD.0.9999.0711210350050.10132@localhost.localdomain>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 03:52:08 -0500 (EST) "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:

> On Wed, 21 Nov 2007, Avi Kivity wrote:
> 
> > Kamalesh Babulal wrote:
> > > Andrew Morton wrote:
> > >
> > > > On Wed, 21 Nov 2007 13:54:50 +0530 Kamalesh Babulal
> > > > <kamalesh@linux.vnet.ibm.com> wrote:
> > > >
> > > >
> > > > > The make headers_check fails,
> > > > >
> > > > >   CHECK   include/linux/usb/gadgetfs.h
> > > > >   CHECK   include/linux/usb/ch9.h
> > > > >   CHECK   include/linux/usb/cdc.h
> > > > >   CHECK   include/linux/usb/audio.h
> > > > >   CHECK   include/linux/kvm.h
> > > > > /root/kernels/linux-2.6.24-rc3/usr/include/linux/kvm.h requires
> > > > > asm/kvm.h, which does not exist in exported headers
> > > > >
> > > > hm, works for me, on i386 and x86_64.  What's different over there?
> > > >
> > > Hi Andrew,
> > >
> > > It fails on the powerpc box, with allyesconfig option.
> >
> > How do we fix this?  Export linux/kvm.h only on x86?  Seems ugly.
> 
> i'm sure i'm going to humiliate myself for asking this, but shouldn't
> i be able to reproduce the above by just running:
> 
>   $ make ARCH=powerpc headers_install/headers_check
> 
> we've sort of had this discussion before where, IIRC, you should be
> able to generate the appropriate arch-specific headers without having
> the corresponding toolchain, no?  so why can't i reproduce that error
> on my x86 box?
> 

I can.

setenv ARCH powerpc
make mrproper
make allmodconfig
make headers_check
