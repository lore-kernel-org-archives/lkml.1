Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbXJVWcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbXJVWcs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbXJVWcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:32:42 -0400
Received: from mail3.sea5.speakeasy.net ([69.17.117.5]:55714 "EHLO
	mail3.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbXJVWcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:32:41 -0400
Date: Mon, 22 Oct 2007 15:32:40 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Andrew Morton <akpm@linux-foundation.org>
cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org
Subject: Re: [i2c] [PATCH] I2C: add support for the PCF8575 chip
In-Reply-To: <20071022145814.84e46287.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0710221522350.16052@shell4.speakeasy.net>
References: <e2e108260710050232s1b0a9cb7u604ab7e20b61646e@mail.gmail.com>
 <20071022145814.84e46287.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, Andrew Morton wrote:
> On Fri, 5 Oct 2007 11:32:35 +0200
> "Bart Van Assche" <bart.vanassche@gmail.com> wrote:
> > +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 20)
> > +static unsigned short normal_i2c_range[] = { I2C_CLIENT_END };
> > +#endif
>
> Please remove all the LINUX_VERSION_CODE tests and target only the current
> mainline tree.

If you want to have a module that can be compiled out of tree and support
multiple kernel versions, there is a script used in the v4l-dvb out of tree
build system that can make it easier.

http://linuxtv.org/hg/v4l-dvb/raw-file/4ae65d0844cf/v4l/scripts/gentree.pl

This script will process #if/#ifdef/#elif/etc.  directives and remove them
from the source.  It is smart enough to understand LINUX_KERNEL_VERSION
tests, && ||, constants, complex expression, etc.  It also knows when the
result of an expression isn't known and will leave it in the code in that
case.  We use it to strip the compat code from the source when it's sent to
the kernel.
