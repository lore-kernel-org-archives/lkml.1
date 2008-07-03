Return-Path: <linux-kernel-owner+w=401wt.eu-S934633AbYGCHLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633AbYGCHLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYGCG6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbYGCFJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 01:09:02 -0400
Date: Wed, 2 Jul 2008 22:08:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Michael Buesch <mb@bu3sch.de>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] gpiolib: Allow user-selection
Message-Id: <20080702220842.44364045.akpm@linux-foundation.org>
In-Reply-To: <200807022200.49428.david-b@pacbell.net>
References: <200807022346.53222.mb@bu3sch.de>
	<20080702170431.56d4c929.akpm@linux-foundation.org>
	<200807022200.49428.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 22:00:49 -0700 David Brownell <david-b@pacbell.net> wrote:

> On Wednesday 02 July 2008, Andrew Morton wrote:
> > On Wed, 2 Jul 2008 23:46:53 +0200
> > Michael Buesch <mb@bu3sch.de> wrote:
> > 
> > > This patch adds functionality to the gpio-lib subsystem to
> > > make it possible to enable the gpio-lib code even if the
> > > architecture code didn't request to get it built in.
> > 
> > drivers/gpio/gpiolib.c: In function 'gpio_export':
> > drivers/gpio/gpiolib.c:432: error: 'struct class' has no member named 'devices'
> > drivers/gpio/gpiolib.c:456: error: implicit declaration of function 'device_create'
> > drivers/gpio/gpiolib.c:457: warning: assignment makes pointer from integer without a cast
> > drivers/gpio/gpiolib.c: In function 'gpio_unexport':
> > drivers/gpio/gpiolib.c:509: warning: passing argument 2 of 'class_find_device' from incompatible pointer type
> > drivers/gpio/gpiolib.c:509: error: too few arguments to function 'class_find_device'
> > drivers/gpio/gpiolib.c: In function 'gpiochip_export':
> > drivers/gpio/gpiolib.c:536: error: 'struct class' has no member named 'devices'
> > drivers/gpio/gpiolib.c:542: warning: assignment makes pointer from integer without a cast
> > drivers/gpio/gpiolib.c: In function 'gpiochip_unexport':
> > drivers/gpio/gpiolib.c:575: warning: passing argument 2 of 'class_find_device' from incompatible pointer type
> > drivers/gpio/gpiolib.c:575: error: too few arguments to function 'class_find_device'
> > 
> > I assume this patch was prepared against some ancient out-of-date
> > kernel such as current Linus mainline.
> 
> May be, but shuffling headers around would not have caused
> that type of breakage.
> 
> I'm thinking some driver model changes broke the gpio sysfs
> interface code, and this happens to show up right now because
> that code wasn't previously getting built.
> 
> Grumph.  I can easily switch the device_create() over to
> use device_create_drvdata() -- didn't I already send in
> a patch like that? -- but the other stuff is completely
> backwards-incompatible.
> 

beats me ididntdoitnobodysawmedoit.

But what I am repeatedly seeing is people cheerfully raising 2.6.27
patches against the 2.6.26 tree when we have a nice 2.6.27 tree for
developing against.  Those days are over, guys.



I'm also seeing obvious signs that developers aren't _testing_ their
new code within the context of the 2.6.27 tree.  They're obviously
testing their stuff against 2.6.26 and then hoping and praying, only it
doesn't always work out for them.

