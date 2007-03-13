Return-Path: <linux-kernel-owner+w=401wt.eu-S965518AbXCMJNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965518AbXCMJNv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 05:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965586AbXCMJNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 05:13:51 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:30572 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965518AbXCMJNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 05:13:50 -0400
Date: Tue, 13 Mar 2007 10:11:59 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Giuliano Pochini <pochini@denise.shiny.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, spyro@f2s.com, rmk@arm.linux.org.uk,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: /sys/devices/system/cpu/cpuX/online are missing
Message-ID: <20070313091159.GB9890@osiris.boeblingen.de.ibm.com>
References: <20070311222652.5ea40da1.pochini@shiny.it> <20070312085826.GA9985@osiris.boeblingen.de.ibm.com> <Pine.LNX.4.64.0703122337350.25919@denise.shiny.it> <je6496asea.fsf@sykes.suse.de> <20070313090350.GA9890@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070313090350.GA9890@osiris.boeblingen.de.ibm.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 10:03:50AM +0100, Heiko Carstens wrote:
> On Tue, Mar 13, 2007 at 01:39:25AM +0100, Andreas Schwab wrote:
> > Giuliano Pochini <pochini@denise.shiny.it> writes:
> > 
> > > I had a look at arch/powerpc/kernel/smp.c but I'm not familiar at all with 
> > > those parts of the kernel.
> > 
> > See arch/powerpc/kernel/sysfs.c:topology_init.  I don't think there is
> > anything to do here.  You probably don't have CONFIG_HOTPLUG_CPU enabled.
> 
> I was referring to arch/ppc not arch/powerpc. But it seems that arch/ppc
> doesn't support cpu hotplug anyway. So I guess it's indeed just a missing
> config option.
> 
> Grepping a bit further shows that arm suffered by the change that inverted
> the logic if the 'online' attribute for cpus should appear. Since arm
> supports cpu hotplug but the patch left arm out, it doesn't work there
> anymore (cc'ing arm people: changeset 72486f1f8f0a2bc828b9d30cf4690cf2dd6807fc
> is most probably disabling cpu hotplug support on arm like it did on s390).

Should have cc'ed Suresh Siddha who caused the breakage ;)
