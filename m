Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZKELUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZKELUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZKELUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:20:16 -0500
Received: from mail.ihtiyat.org ([212.108.130.11]:2352 "EHLO ebim.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750888AbZKELUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:20:14 -0500
Subject: Re: Faulty MTRR setups in Toshiba laptops crash video drivers
From: Mehmet Giritli <mehmet@giritli.eu>
Reply-To: mehmet@giritli.eu
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <51f3faa70911041548x70d5e4a1oabdf1739dad355c7@mail.gmail.com>
References: <1257179328.13327.34.camel@frodo.giritli.eu>
	 <4AEF7402.1010901@gmail.com> <1257253713.6277.7.camel@frodo.giritli.eu>
	 <51f3faa70911041548x70d5e4a1oabdf1739dad355c7@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 05 Nov 2009 13:02:03 +0200
Message-Id: <1257418923.5672.12.camel@frodo.giritli.eu>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 17:48 -0600, Robert Hancock wrote:
> On Tue, Nov 3, 2009 at 7:08 AM, Mehmet Giritli <mehmet@giritli.eu> wrote:
> > On Mon, 2009-11-02 at 18:06 -0600, Robert Hancock wrote:
> >> On 11/02/2009 10:28 AM, Mehmet Giritli wrote:
> >> > Hello all,
> >> >
> >> > On some laptops using ATI 3650HD radeon chipsets and 4GB ram (and may be
> >> > others as well), it is impossible to start any xserver due to (faulty?)
> >> > mtrr setups on the machine. The computer locks up or just gives an
> >> > unresponsive black screen. There are various drivers for radeon cards
> >> > and the crash occurs in all of these drivers in the very same way!
> >> >
> >> > This bug seems to occur mostly on Toshiba laptops with ATI graphic
> >> > cards. For some people, CONFIG_MTRR_SANITIZER seemed to cure the issue
> >> > but made no difference for many others like me.
> >> >
> >> > RadeonHD people seem to have problems in understanding the nature of
> >> > this bug. Please have a look at the threads:
> >> >
> >> > http://lists.opensuse.org/radeonhd/2009-05/msg00040.html
> >> >
> >> > and,
> >> >
> >> > http://bugs.freedesktop.org/show_bug.cgi?id=20645
> >> >
> >> > for problem reports and dev responses. RadeonHD devs suggest that some
> >> > laptops have weird mtrr setups and this must be fixed in the kernel code
> >> > and not the driver code.
> >>
> >> Unfortunately I don't see enough details to be able to tell what lead
> >> them to this conclusion. Can you post the output of:
> >>
> >> lspci -vv
> >> cat /proc/mtrr
> >
> > lspci -vv
> > http://bugzilla.kernel.org/attachment.cgi?id=23634
> >
> > /proc/mtrr when 4GB installed
> > http://bugzilla.kernel.org/attachment.cgi?id=23632
> >
> > /proc/mtrr when 2GB installed
> > http://bugzilla.kernel.org/attachment.cgi?id=23633
> >
> > There is also a bug report that I opened a while back here:
> > http://bugzilla.kernel.org/show_bug.cgi?id=14054
> 
> So it appears that your machine has an MTRR entry which marks the
> first 16MB of the video card's video RAM BAR area as "write-through",
> which seems quite clearly wrong. However, all that I would expect to
> see this do would be to cause X to be unable to map the BAR as
> write-combining (which you can see from dmesg is indeed occurring)
> causing a loss of performance. And the same MTRR is there in the 2GB
> case as in the 4GB case. So I don't think the question of why it works
> with 2GB and not with 4GB is anything to do with MTRRs..

I was using vesafb driver for framebuffer splashscreen and after
removing it from the kernel command line, that 16MB mtrr entry is now
gone. And yes, X was very slow at startup before, now that seems to be
rectified. I don't know if thats another bug or not regarding kernel or
the radeonhd driver.

I should thank you and perhaps especially Yinghai Lu for suggesting it
in the above mentioned bug report.

However, removing vesafb did not make any improvements.

Now I'm wondering if radeonhd developers have anything specific to say
about this...

I will ask on the radeonhd list...


