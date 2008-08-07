Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbYHGStX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbYHGStX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbYHGStM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:49:12 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:22629 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbYHGStL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:49:11 -0400
Date: Thu, 7 Aug 2008 20:49:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: "D. Kelly" <user.kernel@gmail.com>,
       "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
Message-ID: <20080807204900.1c077376@hyperion.delvare>
In-Reply-To: <20080807183944.GA29207@uranus.ravnborg.org>
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
	<20080807131357.59399ddf@hyperion.delvare>
	<20080807183944.GA29207@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008 20:39:44 +0200, Sam Ravnborg wrote:
> > 
> > Alternatively, I am curious if our build system couldn't allow 3rd
> > party drivers to select in-tree modules. Obviously this would require
> > the complete kernel source tree to be available, instead of just the
> > header and config files as is usually the case. Sam, is this possible
> > to do that at this time? If not, is this something that could be
> > implemented, or is this too much work for the thin benefit?
> 
> In general I recommnd to have the full kernel source available
> simply because we have no in-kernel solution to create the required
> set of files to build external modules.
> 
> And today there is no way to hook into the kernel configuration
> for an external module. First of we cannot allow changes in
> the build kernel module as this would destroy module versioning
> for instance.
> 
> And in this case you ask because you would change the kernel
> configuration.
> 
> And I fail to see why this stuff cannot be done inside the
> kernel source tree. Merging new kernel updates should be absolutely
> trivial and then the drivers are better prepared for upstream anyway.

OK, thanks for the clarification.

Maybe one way would be for the external module build system to copy (or
link to) the missing driver source from the kernel tree and build it
locally with the rest of the external drivers, if it wasn't enabled in
the original kernel configuration and they need it. That's probably
just a couple lines of shell script, should be pretty easy. Obviously
this only works for kernel options which only select a given driver and
have no side effect on the rest of the kernel. And this is more
user-friendly than having the user check its kernel configuration and
rebuild his/her kernel.

Just a thought anyway...

-- 
Jean Delvare
