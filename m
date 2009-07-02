Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbZGBKm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbZGBKm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZGBKmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:42:50 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:11732 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751054AbZGBKmt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:42:49 -0400
X-SpamScore: -17
X-BigFish: VPS-17(zz1432R98dN1805Mzz1202hzzz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KM5HQM-01-4CR-01
Date: Thu, 2 Jul 2009 12:41:11 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>, Greg KH <gregkh@suse.de>,
       x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Kurt Garloff <garloff@suse.de>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Doug Thompson <norsk5@yahoo.com>, Dave Jiang <djiang@mvista.com>
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
Message-ID: <20090702104111.GA24940@aftab>
References: <20090624213211.GA11291@kroah.com>
 <alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org>
 <20090630223040.GA3802@suse.de>
 <alpine.LFD.2.00.0907010148490.23134@eddie.linux-mips.org>
 <20090701111003.GC15958@elte.hu>
 <alpine.LFD.2.00.0907011816070.18056@eddie.linux-mips.org>
 <20090702075305.GC19187@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090702075305.GC19187@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Jul 2009 10:41:10.0687 (UTC) FILETIME=[9D26BAF0:01C9FB01]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 09:53:05AM +0200, Ingo Molnar wrote:
> > That shouldn't be a problem if we were about to panic().  For a 
> > more sophisticated attempt of recovery -- yes, that would have to 
> > be addressed.
> 
> We are only panic-ing if the sysctl is set. The diagnostics would be 
> useful anyway. The proper approach would be to defer it a bit in the 
> non-panic case an read it out from some friendlier context - such as 
> the EDAC core.

Quickly skimming through code shows some functionality is there:
drivers/edac/edac_pci{,_sysfs}.c but doesn't seem to be NMI safe. CCing
some more people.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

