Return-Path: <linux-kernel-owner+w=401wt.eu-S1946347AbXBCGGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946347AbXBCGGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 01:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946355AbXBCGGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 01:06:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:7138 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946347AbXBCGGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 01:06:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,275,1167638400"; 
   d="scan'208"; a="195322574:sNHT19534025"
Message-ID: <45C42669.2010105@intel.com>
Date: Fri, 02 Feb 2007 22:06:33 -0800
From: Auke Kok <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>, Adam Kropelin <akropel1@rochester.rr.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jgarzik@pobox.com, alan@lxorguk.ukuu.org.uk,
       Allen Parker <parker@isohunt.com>, Auke Kok <auke-jan.h.kok@intel.com>,
       jesse.brandeburg@intel.com, gregkh@suse.de,
       linux-pci@atrey.karlin.mff.cuni.cz, ebiederm@xmission.com,
       netdev@vger.kernel.org
Subject: Re: 2.6.20-rc7: known regressions (v2) (part 1)
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <20070203004447.GJ3754@stusta.de>
In-Reply-To: <20070203004447.GJ3754@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This email lists some known regressions in 2.6.20-rc7 compared to 2.6.19
> that are not yet fixed in Linus' tree.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way possibly
> involved with one or more of these issues.


> Subject    : e1000: 82571EB/82572EI PCI-E cards: link is always down
>              (MSI related)
> References : http://lkml.org/lkml/2007/1/16/27
>              http://lkml.org/lkml/2007/1/17/182
> Submitter  : Allen Parker <parker@isohunt.com>
>              Adam Kropelin <akropel1@rochester.rr.com>
> Handled-By : Auke Kok <auke-jan.h.kok@intel.com>
> Status     : problem is being debugged

I probably can't fix this bug. Not only do I doubt that the e1000 driver is at 
fault here, I don't have a system with this particular chipset. Most likely the 
regression comes from a combination of MSI layer rewrites and possibly platform 
issues. We've seen many reports that are similar and all are on the platform 
type mentioned here. I really don't want to point fingers here either.

None of the MSI code in e1000 has changed significantly either. as far as I can 
see, the msi code in e1000 has not changed since 2.6.18. Nonetheless there's no 
way I can debug any of this without a system.

I will address the fact that we are lacking any of these systems to test on, but 
that is not going to get this issue handled (not to mention soon) in the way it 
needs to be.

I strongly encourage the people on the linux-pci list to help out, I'll trace 
the e1000 driver for suspicious activity (again), but I run countless tests on 
the latest trees and nothing has shown up recently, other than Eric Biederman's 
msi irq reclaim leak fix.

Perhaps Adam can git-bisect this issue? Adam?

Cheers,

Auke
