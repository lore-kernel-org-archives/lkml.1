Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbXJKRbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbXJKRbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 13:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbXJKRa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 13:30:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbXJKRa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 13:30:58 -0400
Date: Thu, 11 Oct 2007 13:30:34 -0400
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Egger <Christoph.Egger@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: mce init optimization and signedness fixup
Message-ID: <20071011173034.GB21339@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christoph Egger <Christoph.Egger@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <11921050742274-git-send-email-joerg.roedel@amd.com> <200710111601.02630.Christoph.Egger@amd.com> <alpine.LFD.0.9999.0710111651350.15917@localhost.localdomain> <200710111703.35129.Christoph.Egger@amd.com> <alpine.LFD.0.9999.0710111844000.15917@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0710111844000.15917@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 06:50:12PM +0200, Thomas Gleixner wrote:
 > On Thu, 11 Oct 2007, Christoph Egger wrote:
 > > On Thursday 11 October 2007 16:55:36 Thomas Gleixner wrote:
 > > > > > > +
 > > > > > > +	if (!cpu_has(c, X86_FEATURE_MCA) || !cpu_has(c, X86_FEATURE_MCE)) {
 > > > > > > +		printk(KERN_INFO "CPU%i: No machine check support available\n",
 > > > > > > +			smp_processor_id());
 > > > > > > +		return;
 > > > > >
 > > > > > This breaks winchip MCE support.
 > > > >
 > > > > First, what is a winchip? It sounds to be something windows specific. ;)
 > > > > Second, can you explain in which way MCE support gets broken, please?
 > > >
 > > > First, winchip is the code name of Centaurs early x86 cpus.
 > > >
 > > > Second, those beasts do not have FEATURE_MCA, but they have FEATURE_MCE,
 > > > so they support the fatal exception, but not the non fatal check.
 > > 
 > > So when I change the above code snippet to:
 > > 
 > > +	if (!cpu_has(c, X86_FEATURE_MCE)) {
 > > +		printk(KERN_INFO "CPU%i: No machine check support available\n",
 > > +			smp_processor_id());
 > > +		return;
 > > 
 > > Would this make the whole patch acceptable then?
 > 
 > Yeah, but then we can clean up the extra checks for _MCE in the various 
 > cpu type init functions as well.
 
I question the value of adding the printk.
It's not a failure, there's nothing the user can do about it,
and it adds no real value, just more noise to the dmesg.

	Dave

-- 
http://www.codemonkey.org.uk
