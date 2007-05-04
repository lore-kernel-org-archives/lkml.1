Return-Path: <linux-kernel-owner+w=401wt.eu-S1767774AbXEDXS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767774AbXEDXS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767782AbXEDXS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:18:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767774AbXEDXS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:18:56 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] Blacklist Dell Optiplex 320 from using the HPET
Date: Sat, 5 May 2007 01:18:34 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Guilherme M. Schroeder" <guilherme@centralinf.com.br>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <1178314144.6094.7.camel@localhost.localdomain>
In-Reply-To: <1178314144.6094.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705050118.34711.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2007 23:29:04 john stultz wrote:
> One of the 2.6.21 regressions was Guilherme's problem seeing his box
> lock up when the system detected an unstable TSC and dropped back to
> using the HPET.
> 
> In digging deeper, we found the HPET is not actually incrementing on
> this system. And in fact, the reason why this issue just cropped up was
> because of Thomas's clocksource watchdog code was comparing the TSC to
> the HPET (which wasn't moving) and thought the TSC was broken.
> 
> Anyway, Guliherme checked for a BIOS update and did not find one, so
> I've added a DMI blacklist against his system so the HPET is not used.
> 
> Many thanks to Guilherme for the slow and laborious testing that finally
> narrowed down this issue.

Before going to hard to maintain DMI black lists we should first check 
if it's a more general problem and can't it be solved better? Most likely
that system isn't the one with this issue and I don't want to apply
DMI patches forever.

In particular: what lspci chipset does it have?  If it's Intel it might be
worth checking the datasheet if there is some "HPET stop" bit -- perhaps it 
could be fixed up.

We seem to have a couple of Intel systems recently with HPET trouble.

-Andi
