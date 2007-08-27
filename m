Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbXH0MId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbXH0MId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 08:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXH0MHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 08:07:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47629 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751181AbXH0MHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 08:07:48 -0400
Date: Mon, 27 Aug 2007 10:28:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] Hibernation: Arbitrary boot kernel support on x86_64 (updated)
Message-ID: <20070827082808.GH2060@elf.ucw.cz>
References: <200708241206.57178.rjw@sisk.pl> <20070824204632.GA5008@ucw.cz> <200708252027.26721.rjw@sisk.pl> <200708252242.06197.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200708252242.06197.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-08-25 22:42:05, Rafael J. Wysocki wrote:
> On Saturday, 25 August 2007 20:27, Rafael J. Wysocki wrote:
> > On Friday, 24 August 2007 22:46, Pavel Machek wrote:
> > > Hi!
> > > 
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > Make it possible to restore a hibernation image on x86_64 with the help of a
> > > > kernel different from the one in the image.
> > > > 
> > > > The idea is to split the core restoration code into two separate parts and to
> > > > place each of them in a different page.  The first part belongs to the boot
> > > 
> > > What happens in case where both parts want to be
> > > at the same place? (Like kernel being restored is 4KB smaller, so that
> > > routines now collide?)
> > 
> > Bad things, but I can't see how to avoid that reliably.
> 
> Below is an analogous patch without this problem.  The slightly ugly thing
> about it is that all pages in the temporary mapping have the NX bit cleard
> now, so that we can run some code out of one of them.  Still, IMO, that isn't
> really important, because the temporary page tables are dropped as soon as
> we jump to restore_registers.
> 
> Greetings,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make it possible to restore a hibernation image on x86_64 with the help of a
> kernel different from the one in the image.
> 
> The idea is to split the core restoration code into two separate parts and to
> place each of them in a different page.  The first part belongs to the boot
> kernel and is executed as the last step of the image kernel's memory restoration
> procedure.  Before being executed, it is relocated to a safe page that won't be
> overwritten while copying the image kernel pages.
> 
> The final operation performed by it is a jump to the second part of the core
> restoration code that belongs to the image kernel and has just been restored.
> This code makes the CPU switch to the image kernel's page tables and
> restores the state of general purpose registers (including the stack pointer)
> from before the hibernation.
> 
> The main issue with this idea is that in order to jump to the second part of the
> core restoration code the boot kernel needs to know its address.  However, this
> address may be passed to it in the image header.  Namely, the part of the image
> header previously used for checking if the version of the image kernel is
> correct can be replaced with some architecture specific data that will allow
> the boot kernel to jump to the right address within the image kernel.  These
> data should also be used for checking if the image kernel is compatible with
> the boot kernel (as far as the memory restroration procedure is concerned).
> It can be done, for example, with the help of a "magic" value that has to be
> equal in both kernels, so that they can be regarded as compatible.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
ACK.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
