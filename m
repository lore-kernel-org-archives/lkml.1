Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbYADCjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbYADCjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 21:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYADCjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 21:39:17 -0500
Received: from ozlabs.org ([203.10.76.45]:53167 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbYADCjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 21:39:17 -0500
Date: Fri, 4 Jan 2008 10:35:09 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Jochen Friedrich <jochen@scram.de>
Cc: linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
       linux-kernel@vger.kernel.org,
       "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
Subject: Re: [PATCHv3] powerpc: DBox2 Board Support
Message-ID: <20080103233509.GB12883@localhost.localdomain>
Mail-Followup-To: Jochen Friedrich <jochen@scram.de>,
	linuxppc-dev@ozlabs.org, Scott Wood <scottwood@freescale.com>,
	linux-kernel@vger.kernel.org,
	"linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>
References: <477522DB.4000100@scram.de> <20080102112030.GB23168@localhost.localdomain> <477CCB0F.8020504@scram.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477CCB0F.8020504@scram.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 12:46:23PM +0100, Jochen Friedrich wrote:
> Hi David,
> 
> >> +/ {
> >> +	model = "unknown,dbox2"; // boot wrapper fills in correct manufacturer
> > 
> > Probably better just to leave model out of the dts and let the
> > bootwrapper add it.
> 
> Unfortunately, dtc requires a model:
> 
> $ dtc arch/powerpc/boot/dts/dbox2.dts
> DTC: dts->dts  on file "arch/powerpc/boot/dts/dbox2.dts"
> ERROR: Missing "model" property in /

Ah.  That should be gone in newer dtc versions.  I'm pretty sure I got
rid of all checks that enforced the presence of particular properties,
precisely because they give frequent spurious errors when things are
supposed to be filled in by the bootloader.

[snip]
> >> +				label = "Flash without bootloader";
> >> +				reg = <20000 7e0000>;
> >> +			};
> >> +			ovpartition@0 {
> >> +				label = "Complete Flash";
> >> +				reg = <0 800000>;
> >> +				read-only;
> >> +			};
> >> +		};
> >> +	};
> 
> MTD handles this correctly. dbox2 uses "Flash without bootloader"
> for flashing image updates and "Complete Flash" for creating a
> backup of everything.  OpenWRT also uses overlapping partitions BTW
> (and also for flashing updates).

Heh.  Wow.  Safely?  i.e. if you access one partition then later an
overlapping partition, is mtd guaranteed to get the necessary
synchronization right?

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
