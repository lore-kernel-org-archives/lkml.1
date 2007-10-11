Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbXJKPER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbXJKPER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbXJKPEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:04:07 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:14379 "EHLO
	outbound1-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753669AbXJKPEF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:04:05 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
From: "Christoph Egger" <Christoph.Egger@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] x86: mce init optimization and signedness fixup
Date: Thu, 11 Oct 2007 17:03:34 +0200
User-Agent: KMail/1.9.6
cc: "Joerg Roedel" <joerg.roedel@amd.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <11921050742274-git-send-email-joerg.roedel@amd.com>
 <200710111601.02630.Christoph.Egger@amd.com>
 <alpine.LFD.0.9999.0710111651350.15917@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710111651350.15917@localhost.localdomain>
MIME-Version: 1.0
Message-ID: <200710111703.35129.Christoph.Egger@amd.com>
X-OriginalArrivalTime: 11 Oct 2007 15:03:51.0930 (UTC)
 FILETIME=[EF570DA0:01C80C17]
X-WSS-ID: 6B10E4D013S1724688-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 October 2007 16:55:36 Thomas Gleixner wrote:
> On Thu, 11 Oct 2007, Christoph Egger wrote:
> > On Thursday 11 October 2007 15:51:49 Thomas Gleixner wrote:
> > > On Thu, 11 Oct 2007, Joerg Roedel wrote:
> > > > MCG_CAP never reports a negative count of available error-reporting
> > > > banks. Therefore, make nr_mce_banks unsigned.
> > > > Check for MCA/MCE feature bits as early as possible.
> > > >
> > > > +
> > > > +	if (!cpu_has(c, X86_FEATURE_MCA) || !cpu_has(c, X86_FEATURE_MCE)) {
> > > > +		printk(KERN_INFO "CPU%i: No machine check support available\n",
> > > > +			smp_processor_id());
> > > > +		return;
> > >
> > > This breaks winchip MCE support.
> >
> > First, what is a winchip? It sounds to be something windows specific. ;)
> > Second, can you explain in which way MCE support gets broken, please?
>
> First, winchip is the code name of Centaurs early x86 cpus.
>
> Second, those beasts do not have FEATURE_MCA, but they have FEATURE_MCE,
> so they support the fatal exception, but not the non fatal check.

So when I change the above code snippet to:

+	if (!cpu_has(c, X86_FEATURE_MCE)) {
+		printk(KERN_INFO "CPU%i: No machine check support available\n",
+			smp_processor_id());
+		return;

Would this make the whole patch acceptable then?



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


