Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbYDNVJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbYDNVJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 17:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbYDNVJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 17:09:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45354 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757931AbYDNVJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 17:09:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: x86 git tree broken (bisected)
Date: Mon, 14 Apr 2008 23:09:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Thomas Gleixner" <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       "Arjan van de Ven" <arjan@infradead.org>
References: <200804102159.14563.rjw@sisk.pl> <200804142221.19606.rjw@sisk.pl> <86802c440804141406u7543dbacifb4b93b7b0ee2cc3@mail.gmail.com>
In-Reply-To: <86802c440804141406u7543dbacifb4b93b7b0ee2cc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804142309.29586.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Yinghai Lu wrote:
> On Mon, Apr 14, 2008 at 1:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > On Monday, 14 of April 2008, Yinghai Lu wrote:
> >  > On Sun, Apr 13, 2008 at 5:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >  > >
> >  > > On Monday, 14 of April 2008, Yinghai Lu wrote:
> >  > >  > On Sun, Apr 13, 2008 at 3:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >  > >  > >
> >  > >  > > On Monday, 14 of April 2008, Yinghai Lu wrote:
> >  > >  > >  > On Sun, Apr 13, 2008 at 9:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >  > >  > >  > ...
> >  > >  > >  > >  > can you try to apply the patch i sent to you about agp bridge order
> >  > >  > >  > >  > reading for buggy silicon?
> >  > >  > >  > >  >
> >  > >  > >  > >  > Please boot kernel with "debug"...
> >  > >  > >  > >  >
> >  > >  > >  > >  > I want to verify if you can get
> >  > >  > >  > >  >
> >  > >  > >  > >  > "
> >  > >  > >  > >  > Aperture conflicts with PCI mapping.
> >  > >  > >  > >  > "
> >  > >  > >  > >  >
> >  > >  > >  > >  > in your boot log...
> >  > >  > >  > >
> >  > >  > >  > >  It's not present in there:
> >  > >  > >  > >
> >  > >  > >  > >  rafael@albercik:~> grep Aperture failing-with-patch-dmesg.log
> >  > >  > >  > >  Aperture too small (32 MB)
> >  > >  > >  > >  Aperture from AGP @ de000000 size 4096 MB (APSIZE 0)
> >  > >  > >  > >  Aperture too small (0 MB)
> >  > >  > >  > >  agpgart: Aperture pointing to RAM
> >  > >  > >  > >  agpgart: Aperture from AGP @ de000000 size 4096 MB
> >  > >  > >  > >  agpgart: Aperture too small (0 MB)
> >  > >  > >  > >
> >  > >  > >  > >  Full dmesg output attached.
> >  > >  > >  >
> >  > >  > >  > please check attached debug patch. and check if you can change GART
> >  > >  > >  > size in your BIOS setup to 64M instead of 32M
> >  > >  > >
> >  > >  > >  Hm, what tree am I supposed to apply it too:
> >  > >  > >  (1) current x86 git
> >  > >  > >  (2) current x86 git w/ some of your previous patches (which ones in this case)
> >  > >  > >  (3) failing (old) x86 git
> >  > >  > >  (4) failing (old) x86 git w/ some of your previous patches (which ones in this
> >  > >  > >     case)?
> >  > >  >
> >  > >  > (1) current x86.git
> >  > >
> >  > >  Attached is dmesg output from current x86.git with debug_gart_checking.patch
> >  > >  applied.
> >  >
> >  > please test the final one ... ...
> >  >
> >  > You should get back 64M memory back.
> >
> >  Tested (current x86.git), dmesg output attached.
> 
> thanks.
> 
> looks good. as expected...
> 
> Checking aperture...
> AGP bridge at 00:04:00
> Aperture from AGP @ de000000 old size 32 MB
> Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
> Aperture from AGP @ de000000 size 32 MB (APSIZE 0)
> Node 0: aperture @ de000000 size 32 MB
> Aperture too small (32 MB) than (64 MB)
> ...
> agpgart: Detected AGP bridge 20
> Setting up ULi AGP.
> agpgart: AGP aperture is 32M @ 0xde000000

BTW, what exactly would be the benefit of increasing the aperture size, given
that I use a PCI Express graphics adapter?

Rafael
