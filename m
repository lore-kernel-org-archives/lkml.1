Return-Path: <linux-kernel-owner+w=401wt.eu-S1759676AbXJLHrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676AbXJLHrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXJLHqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:46:53 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:46795 "EHLO
	outbound2-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148AbXJLHqw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:46:52 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
From: "Christoph Egger" <Christoph.Egger@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: mce init optimization and signedness fixup
Date: Fri, 12 Oct 2007 09:44:02 +0200
User-Agent: KMail/1.9.6
cc: "Joerg Roedel" <joerg.roedel@amd.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <11921050742274-git-send-email-joerg.roedel@amd.com>
 <200710111703.35129.Christoph.Egger@amd.com>
 <alpine.LFD.0.9999.0710111844000.15917@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710111844000.15917@localhost.localdomain>
MIME-Version: 1.0
Message-ID: <200710120944.02953.Christoph.Egger@amd.com>
X-OriginalArrivalTime: 12 Oct 2007 07:45:03.0528 (UTC)
 FILETIME=[CCCD7A80:01C80CA3]
X-WSS-ID: 6B11F9B013S1799637-05-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007 18:50:12 Thomas Gleixner wrote:
> On Thu, 11 Oct 2007, Christoph Egger wrote:
> > On Thursday 11 October 2007 16:55:36 Thomas Gleixner wrote:
> > > > > > +
> > > > > > +	if (!cpu_has(c, X86_FEATURE_MCA) || !cpu_has(c,
> > > > > > X86_FEATURE_MCE)) { +		printk(KERN_INFO "CPU%i: No machine check
> > > > > > support available\n", +			smp_processor_id());
> > > > > > +		return;
> > > > >
> > > > > This breaks winchip MCE support.
> > > >
> > > > First, what is a winchip? It sounds to be something windows specific.
> > > > ;) Second, can you explain in which way MCE support gets broken,
> > > > please?
> > >
> > > First, winchip is the code name of Centaurs early x86 cpus.
> > >
> > > Second, those beasts do not have FEATURE_MCA, but they have
> > > FEATURE_MCE, so they support the fatal exception, but not the non fatal
> > > check.
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

Will you do the little modification in your tree after applying my patch
or do you want me to resend the patch with that little modification.

Christoph


-- 
AMD Saxony, Dresden, Germany
Operating System Research Center

Legal Information:
AMD Saxony Limited Liability Company & Co. KG
Sitz (Geschäftsanschrift):
   Wilschdorfer Landstr. 101, 01109 Dresden, Deutschland
Registergericht Dresden: HRA 4896
vertretungsberechtigter Komplementär:
   AMD Saxony LLC (Sitz Wilmington, Delaware, USA)
Geschäftsführer der AMD Saxony LLC:
   Dr. Hans-R. Deppe, Thomas McCoy


