Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYDWSj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYDWSj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYDWSjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:39:22 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62031 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751162AbYDWSjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:39:21 -0400
Date: Wed, 23 Apr 2008 19:38:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Jean Delvare <jdelvare@suse.de>, Andi Kleen <andi@firstfloor.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Tejun Heo <htejun@gmail.com>,
       Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PCI MSI breaks when booting with nosmp
In-Reply-To: <200804231123.46506.jbarnes@virtuousgeek.org>
Message-ID: <Pine.LNX.4.55.0804231927420.31934@cliff.in.clinika.pl>
References: <200804172140.02311.jdelvare@suse.de> <200804230812.49548.jbarnes@virtuousgeek.org>
 <Pine.LNX.4.55.0804231855510.31934@cliff.in.clinika.pl>
 <200804231123.46506.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Jesse Barnes wrote:

> Yeah, I'm not particularly attached to either meaning.  It looks like we'll 
> setup the local apic on 32 bit if the NMI vector is a local apic one, so in 
> that case at least the behavior will be the same.

 Well, I did not follow changes to the code over the years and I think
enabling the local APIC for the NMI watchdog does not fit the semantics of
"nosmp" very well either.  If you want the watchdog, then you can use 
"maxcpus=1" or "maxcpus=1 noapic".

> Anyway, we have two options:
>   1) make nosmp/maxcpus=1 imply nolapic (and therefore disable MSI too)
>   2) make nosmp enable the lapic (so MSI will work)

 Well, I have a slight affinity towards the first one (with "maxcpus=0"  
that is; I'm assuming it's a typo above), but I do not think that is
something to be fiercely fought either.

  MAciej
