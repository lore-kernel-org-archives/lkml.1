Return-Path: <linux-kernel-owner+w=401wt.eu-S932314AbZJSWhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbZJSWhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 18:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757553AbZJSWhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 18:37:03 -0400
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:60631
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbZJSWhC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 18:37:02 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 18:37:02 EDT
Date: Tue, 20 Oct 2009 07:30:39 +0900
From: Mattia Dongili <malattia@linux.it>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Message-ID: <20091019223039.GA4367@kamineko.org>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain>
 <200910190619.48037.arnd@arndb.de>
 <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain>
 <200910200000.24574.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910200000.24574.arnd@arndb.de>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.32-rc4 x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 12:00:24AM +0200, Arnd Bergmann wrote:
> On Monday 19 October 2009, John Kacur wrote:
> > How does this look? (Version 2 of the patch follows)
> 
> Looks good now.

Looks alright to me too.

> > From efd07cfcd021b4438d83d383ab81f9b35cb41eb9 Mon Sep 17 00:00:00 2001
> > From: John Kacur <jkacur@redhat.com>
> > Date: Sun, 18 Oct 2009 23:49:49 +0200
> > Subject: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
> > 
> > The BKL is in this function because of the BKL pushdown
> > (see commit f8f2c79d594463427f7114cedb1555110d547d89)
> > 
> > It is not needed here because the mutex_lock sonypi_device.lock
> > provides the necessary locking.
> > 
> > sonpi_misc_ioctl can be converted to unlocked ioctls since it relies on
> > its own locking (the mutex sonypi_device.lock) and not the bkl
> > 
> > Signed-off-by: John Kacur <jkacur@redhat.com>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Mattia Dongili <malattia@linux.it>
-- 
mattia
:wq!
