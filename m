Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbYDWSY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbYDWSY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbYDWSYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:24:22 -0400
Received: from outbound-mail-119.bluehost.com ([69.89.22.19]:36189 "HELO
	outbound-mail-119.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753847AbYDWSYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:24:21 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: PCI MSI breaks when booting with nosmp
Date: Wed, 23 Apr 2008 11:23:45 -0700
User-Agent: KMail/1.9.9
Cc: Jean Delvare <jdelvare@suse.de>, Andi Kleen <andi@firstfloor.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200804172140.02311.jdelvare@suse.de> <200804230812.49548.jbarnes@virtuousgeek.org> <Pine.LNX.4.55.0804231855510.31934@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0804231855510.31934@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231123.46506.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 131.252.210.190 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2008 11:13 am Maciej W. Rozycki wrote:
> On Wed, 23 Apr 2008, Jesse Barnes wrote:
> > Yeah I think the patch is reasonable, would be good to get feedback from
> > Thomas/Andi/Ingo though...
>
>  FWIW, the original idea behind "nosmp" or "maxcpus=0" (just as an
> implementation detail) vs "maxcpus=1" was that the two formers would
> disable the APIC circuitry altogether (including resisting from switching
> from the PIC compatibility mode on systems supporting it), while the
> latter would still boot UP, but with interrupts routed through the APICs.
> Essentially SMP implied all the MP circuitry/provisions in this context,
> the APICs being an inherent part of which.  Therefore I think the original
> idea of implying "pci=nomsi" with "nosmp" certainly looks more in the
> spirit of the original setup to me.
>
>  However we have "nolapic" these days as well and with this new proposal
> this option could effectively take over the old meaning of "nosmp" (you
> cannot do SMP without the local APIC, so "nolapic nosmp" is redundant).
> I am not entirely convinced it is the right way though...

Yeah, I'm not particularly attached to either meaning.  It looks like we'll 
setup the local apic on 32 bit if the NMI vector is a local apic one, so in 
that case at least the behavior will be the same.

Anyway, we have two options:
  1) make nosmp/maxcpus=1 imply nolapic (and therefore disable MSI too)
  2) make nosmp enable the lapic (so MSI will work)

Jesse
