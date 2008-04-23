Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbYDWSPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbYDWSPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYDWSPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:15:07 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61878 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753654AbYDWSPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:15:05 -0400
Date: Wed, 23 Apr 2008 19:13:07 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Jean Delvare <jdelvare@suse.de>, Andi Kleen <andi@firstfloor.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PCI MSI breaks when booting with nosmp
In-Reply-To: <200804230812.49548.jbarnes@virtuousgeek.org>
Message-ID: <Pine.LNX.4.55.0804231855510.31934@cliff.in.clinika.pl>
References: <200804172140.02311.jdelvare@suse.de> <200804211414.45629.jbarnes@virtuousgeek.org>
 <200804231638.01479.jdelvare@suse.de> <200804230812.49548.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Jesse Barnes wrote:

> Yeah I think the patch is reasonable, would be good to get feedback from 
> Thomas/Andi/Ingo though...

 FWIW, the original idea behind "nosmp" or "maxcpus=0" (just as an
implementation detail) vs "maxcpus=1" was that the two formers would
disable the APIC circuitry altogether (including resisting from switching
from the PIC compatibility mode on systems supporting it), while the
latter would still boot UP, but with interrupts routed through the APICs.  
Essentially SMP implied all the MP circuitry/provisions in this context,
the APICs being an inherent part of which.  Therefore I think the original
idea of implying "pci=nomsi" with "nosmp" certainly looks more in the
spirit of the original setup to me.

 However we have "nolapic" these days as well and with this new proposal
this option could effectively take over the old meaning of "nosmp" (you
cannot do SMP without the local APIC, so "nolapic nosmp" is redundant).  
I am not entirely convinced it is the right way though...

  Maciej
