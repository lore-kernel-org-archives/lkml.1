Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbXI2Uxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbXI2Uxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 16:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbXI2Ux2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 16:53:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51230 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606AbXI2Ux1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 16:53:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: regression in 2.6.23-rc8 - power off failed
Date: Sat, 29 Sep 2007 23:08:12 +0200
User-Agent: KMail/1.9.5
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, Mark Lord <lkml@rtr.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20070929005453.GA4475@erig.dyndns.org> <46FE6E17.6070109@suse.de> <46FEB9CA.9090703@tmr.com>
In-Reply-To: <46FEB9CA.9090703@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709292308.13593.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 29 September 2007 22:47, Bill Davidsen wrote:
> Alexey Starikovskiy wrote:
> 
> > -static void
> > -acpi_power_off (void)
> > -{
> > -       printk("%s called\n",__FUNCTION__);
> > -       /* Some SMP machines only can poweroff in boot CPU */
> > -       set_cpus_allowed(current, cpumask_of_cpu(0));
> > ACPI in kernel 2.6.12 did disable non-boot cpus too in powe_off.
> > Later only comment was left for some reason...
> > 
> Am I midreading that code, or does it really assume that the boot cpu is 
> always zero? Or just that zero will be able to do the power off?
> 
> In any case I have had an SMP machine which did not have a CPU zero, and 
> it was discussed here, I believe. Wonder what happens if you set 
> affinity to a CPU you don't have...

Good question, but it also caused other problems to appear, IIRC.

IMHO, it's better to call disable_nonboot_cpus() in an appropriate place
anyway.

Greetings,
Rafael
