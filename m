Return-Path: <linux-kernel-owner+w=401wt.eu-S934536AbYGCHK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934536AbYGCHK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYGCG6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:14 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:26144 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753088AbYGCFAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 01:00:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UYl67G/LpBQk9LacJmTIB6DwTA2G0yNWMx6MkgNM9gn6lVRuvAq5sp5dtSxPx0wEqYK6F599XEzMCoCI8TsOP3ATyNQSGUlFFfkjhZT5yuJwGpV0B2ff6xwmDDhfBG5XS5RupgoDHHtrhxe/JcydvnQ2+i6RirgsRfSaLRohvVc=  ;
X-YMail-OSG: kxVPISwVM1mBPiCqJ8UuN3wt2C33.vGDOppyVfXcLyb._.Z9OvyPb1POoXw1S4qc3bLIlxylSZSekMFcZSUKcTPW8RW8zVJITsq_7inX_Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gpiolib: Allow user-selection
Date: Wed, 2 Jul 2008 22:00:49 -0700
User-Agent: KMail/1.9.9
Cc: Michael Buesch <mb@bu3sch.de>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
References: <200807022346.53222.mb@bu3sch.de> <20080702170431.56d4c929.akpm@linux-foundation.org>
In-Reply-To: <20080702170431.56d4c929.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807022200.49428.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2008, Andrew Morton wrote:
> On Wed, 2 Jul 2008 23:46:53 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > This patch adds functionality to the gpio-lib subsystem to
> > make it possible to enable the gpio-lib code even if the
> > architecture code didn't request to get it built in.
> 
> drivers/gpio/gpiolib.c: In function 'gpio_export':
> drivers/gpio/gpiolib.c:432: error: 'struct class' has no member named 'devices'
> drivers/gpio/gpiolib.c:456: error: implicit declaration of function 'device_create'
> drivers/gpio/gpiolib.c:457: warning: assignment makes pointer from integer without a cast
> drivers/gpio/gpiolib.c: In function 'gpio_unexport':
> drivers/gpio/gpiolib.c:509: warning: passing argument 2 of 'class_find_device' from incompatible pointer type
> drivers/gpio/gpiolib.c:509: error: too few arguments to function 'class_find_device'
> drivers/gpio/gpiolib.c: In function 'gpiochip_export':
> drivers/gpio/gpiolib.c:536: error: 'struct class' has no member named 'devices'
> drivers/gpio/gpiolib.c:542: warning: assignment makes pointer from integer without a cast
> drivers/gpio/gpiolib.c: In function 'gpiochip_unexport':
> drivers/gpio/gpiolib.c:575: warning: passing argument 2 of 'class_find_device' from incompatible pointer type
> drivers/gpio/gpiolib.c:575: error: too few arguments to function 'class_find_device'
> 
> I assume this patch was prepared against some ancient out-of-date
> kernel such as current Linus mainline.

May be, but shuffling headers around would not have caused
that type of breakage.

I'm thinking some driver model changes broke the gpio sysfs
interface code, and this happens to show up right now because
that code wasn't previously getting built.

Grumph.  I can easily switch the device_create() over to
use device_create_drvdata() -- didn't I already send in
a patch like that? -- but the other stuff is completely
backwards-incompatible.

- Dave


> 
> Guys, we have a new development tree now.
> 


