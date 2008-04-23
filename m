Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbYDWSch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbYDWSch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYDWSc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:32:29 -0400
Received: from ns2.suse.de ([195.135.220.15]:51404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbYDWSc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:32:28 -0400
From: Jean Delvare <jdelvare@suse.de>
Organization: SuSE Linux
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Wed, 23 Apr 2008 20:32:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Andi Kleen <andi@firstfloor.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Tejun Heo <htejun@gmail.com>, Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200804172140.02311.jdelvare@suse.de> <Pine.LNX.4.55.0804231855510.31934@cliff.in.clinika.pl> <200804231123.46506.jbarnes@virtuousgeek.org>
In-Reply-To: <200804231123.46506.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804232032.39550.jdelvare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 23 avril 2008, Jesse Barnes a écrit :
> On Wednesday, April 23, 2008 11:13 am Maciej W. Rozycki wrote:
> > On Wed, 23 Apr 2008, Jesse Barnes wrote:
> > > Yeah I think the patch is reasonable, would be good to get feedback from
> > > Thomas/Andi/Ingo though...
> >
> >  FWIW, the original idea behind "nosmp" or "maxcpus=0" (just as an
> > implementation detail) vs "maxcpus=1" was that the two formers would
> > disable the APIC circuitry altogether (including resisting from switching
> > from the PIC compatibility mode on systems supporting it), while the
> > latter would still boot UP, but with interrupts routed through the APICs.
> > Essentially SMP implied all the MP circuitry/provisions in this context,
> > the APICs being an inherent part of which.  Therefore I think the original
> > idea of implying "pci=nomsi" with "nosmp" certainly looks more in the
> > spirit of the original setup to me.
> >
> >  However we have "nolapic" these days as well and with this new proposal
> > this option could effectively take over the old meaning of "nosmp" (you
> > cannot do SMP without the local APIC, so "nolapic nosmp" is redundant).
> > I am not entirely convinced it is the right way though...
> 
> Yeah, I'm not particularly attached to either meaning.  It looks like we'll 
> setup the local apic on 32 bit if the NMI vector is a local apic one, so in 
> that case at least the behavior will be the same.
> 
> Anyway, we have two options:
>   1) make nosmp/maxcpus=1 imply nolapic (and therefore disable MSI too)
>   2) make nosmp enable the lapic (so MSI will work)

No opinion. As long as I can boot with "nosmp" and things work, I'm
happy.

-- 
Jean Delvare
Suse L3
