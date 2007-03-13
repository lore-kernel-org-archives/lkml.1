Return-Path: <linux-kernel-owner+w=401wt.eu-S965632AbXCMJk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965632AbXCMJk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965658AbXCMJk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:40:56 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3101 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965632AbXCMJkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:40:55 -0400
Date: Tue, 13 Mar 2007 09:40:39 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andreas Schwab <schwab@suse.de>,
       Giuliano Pochini <pochini@denise.shiny.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: /sys/devices/system/cpu/cpuX/online are missing
Message-ID: <20070313094038.GA20518@flint.arm.linux.org.uk>
Mail-Followup-To: Heiko Carstens <heiko.carstens@de.ibm.com>,
	Andreas Schwab <schwab@suse.de>,
	Giuliano Pochini <pochini@denise.shiny.it>, linuxppc-dev@ozlabs.org,
	linux-kernel@vger.kernel.org,
	Suresh Siddha <suresh.b.siddha@intel.com>
References: <20070311222652.5ea40da1.pochini@shiny.it> <20070312085826.GA9985@osiris.boeblingen.de.ibm.com> <Pine.LNX.4.64.0703122337350.25919@denise.shiny.it> <je6496asea.fsf@sykes.suse.de> <20070313090350.GA9890@osiris.boeblingen.de.ibm.com> <20070313091159.GB9890@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313091159.GB9890@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 10:11:59AM +0100, Heiko Carstens wrote:
> On Tue, Mar 13, 2007 at 10:03:50AM +0100, Heiko Carstens wrote:
> > On Tue, Mar 13, 2007 at 01:39:25AM +0100, Andreas Schwab wrote:
> > > Giuliano Pochini <pochini@denise.shiny.it> writes:
> > > 
> > > > I had a look at arch/powerpc/kernel/smp.c but I'm not familiar at all with 
> > > > those parts of the kernel.
> > > 
> > > See arch/powerpc/kernel/sysfs.c:topology_init.  I don't think there is
> > > anything to do here.  You probably don't have CONFIG_HOTPLUG_CPU enabled.
> > 
> > I was referring to arch/ppc not arch/powerpc. But it seems that arch/ppc
> > doesn't support cpu hotplug anyway. So I guess it's indeed just a missing
> > config option.
> > 
> > Grepping a bit further shows that arm suffered by the change that inverted
> > the logic if the 'online' attribute for cpus should appear. Since arm
> > supports cpu hotplug but the patch left arm out, it doesn't work there
> > anymore (cc'ing arm people: changeset 72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc
> > is most probably disabling cpu hotplug support on arm like it did on s390).
> 
> Should have cc'ed Suresh Siddha who caused the breakage ;)

Welcome to why cleanups are bad news. ;(  Yes, ARM also needs to be fixed
and I'd ask that in future people doing cleanups in core code take a little
more time to review the code before submitting patches *AND* give heads-up
to *EVERYONE* who might be affected by the change.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
