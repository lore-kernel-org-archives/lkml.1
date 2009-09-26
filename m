Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZIZSsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZIZSsh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZIZSsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:48:31 -0400
Received: from fifo99.com ([67.223.236.141]:52417 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbZIZSsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:48:30 -0400
Subject: Re: Staging: dream: fix build errorsg
From: Daniel Walker <dwalker@fifo99.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, kernel list <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, arve@android.com,
       swetland@google.com
In-Reply-To: <20090926114408.GC3105@ucw.cz>
References: <20090911212751.GA25544@elf.ucw.cz>
	 <20090916174803.GA28689@kroah.com>  <20090926114408.GC3105@ucw.cz>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 11:48:01 -0700
Message-Id: <1253990881.20648.427.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-26 at 13:44 +0200, Pavel Machek wrote:
> On Wed 2009-09-16 10:48:03, Greg KH wrote:
> > On Fri, Sep 11, 2009 at 11:27:52PM +0200, Pavel Machek wrote:
> > > 
> > > Fix compilation of gpio_* input drivers on -next kernel. Adds needed
> > > headers and removes unprotected wakelock/earlysuspend dependencies.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > ---
> > >  drivers/staging/dream/gpio_event.c  |    3 
> > >  drivers/staging/dream/gpio_input.c  |    7 -
> > >  drivers/staging/dream/gpio_matrix.c |    8 -
> > >  include/linux/gpio_event.h          |  154 ++++++++++++++++++++++++++++++++++++
> > 
> > This adds a file outside of the staging tree, so I'm going to drop it,
> > sorry.
> 
> Ok, whats the preffered solution here? Create staging/include/linux
> and add gcc -I magic so it gets used?

Could we do drivers/staging/include/ then make a link from
include/staging/ (or something) into the drivers/staging include
directory at build time?

The lower level msm sub-architecture already links to includes directly
into the staging directory like this,

#include <../../../drivers/staging/android/timed_gpio.h>

which looks pretty ugly ..

Daniel

