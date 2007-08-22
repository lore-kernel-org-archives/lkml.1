Return-Path: <linux-kernel-owner+w=401wt.eu-S1764357AbXHVPGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764357AbXHVPGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 11:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762967AbXHVPFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 11:05:33 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39635 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761074AbXHVPFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 11:05:31 -0400
Date: Wed, 22 Aug 2007 10:26:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH -mm 2/4] Hibernation: Arbitrary boot kernel support on x86_64
Message-ID: <20070822082613.GB2479@elf.ucw.cz>
References: <200708221015.16493.rjw@sisk.pl> <200708221019.03798.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708221019.03798.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2007-08-22 10:19:03, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make it possible to restore a hibernation image on x86_64 with the help of a
> kernel different from the one in the image.
> 
> The idea is to split the core restoration code into two separate parts and to
> place each of them in a different page.  The first part belongs to the boot
> kernel and is executed as the last step of the image kernel's memory restoration
> procedure.  It restores all of the image kernel's memory that has not been
> restored yet except for the one page containing the very code that is being
> executed at that time.  The final operation performed by it is a jump to the
> second part of the core restoration code that belongs to the image kernel and
> has just been restored.  This code restores the last remaining page of the image
> kernel's memory containing the first, already executed, part of the core
> restoration code (temporary page tables created by the boot kernel are used at
> this stage).  It also makes the CPU switch to the image kernel's page tables and
> restores the state of general purpose registers (including the stack pointer)
> from before the hibernation.
> 
> The main issue with this idea is that in order to jump to the second part of the
> restoration code the boot kernel needs to know its address.  However, this
> address may be passed to it in the image header.  Namely, the part of the image
> header previously used for checking if the version of the image kernel is
> correct can be replaced with some architecture specific data that will allow
> the boot kernel to jump to the right address within the image kernel.  These
> data should also be used for checking if the image kernel is compatible with
> the boot kernel (as far as the memory restroration procedure is concerned).
> It can be done, for example, with the help of a "magic" value that has to be
> equal in both kernels, so that they can be regarded as compatible.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
