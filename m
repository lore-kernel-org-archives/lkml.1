Return-Path: <linux-kernel-owner+w=401wt.eu-S1754550AbYI3Pxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbYI3Pxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYI3PxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:53:25 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:48334 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbYI3PxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:53:24 -0400
Message-ID: <48E24C6F.3030903@keyaccess.nl>
Date: Tue, 30 Sep 2008 17:57:35 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org, Adam Belay <abelay@mit.edu>,
       Avuton Olrich <avuton@gmail.com>,
       Karl Bellve <karl.bellve@umassmed.edu>, Willem Riede <wriede@riede.org>,
       Matthew Hall <mhall@mhcomputing.net>
Subject: Re: [patch 2/2] PNP: don't check disabled PCI BARs for conflicts
 in quirk_system_pci_resources()
References: <200809290953.56565.bjorn.helgaas@hp.com> <200809290957.59813.bjorn.helgaas@hp.com> <alpine.LFD.1.10.0809290912060.3265@nehalem.linux-foundation.org> <48E11EFA.8010402@keyaccess.nl> <alpine.LFD.2.00.0809291211330.3389@nehalem.linux-foundation.org> <48E1EF0E.8030006@keyaccess.nl> <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0809300741320.3389@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30-09-08 16:48, Linus Torvalds wrote:

> I think you got the logic the wrong way around:
> 
> +                       /* have we been registered already? */
> +                       if (pci_res->parent)
> +                               continue;
> 
> This ignores resources that are _registered_, but it should be the other 
> way around - we should ignore resources that aren't (because they may be 
> invalid or they may move around)

Arr. Yes, ofcourse. Okay... that ain't working:

> Of course, it may be that the PnP code runs too early, and we have 
> only parsed the PCI resources, not inserted them into the resource 
> tree yet. If so, none of this will work, of course.

It doesn't. With the test negated it triggers for all PCI resources (and 
ofcourse my soundcard driver fails again).

If the simple res->start == 0/SOME_ARCH_DEFINE definitely won't do and 
the issue with Bjorn's approach is the bus hammering the solution might 
be to set a per resource flag in pci_dev at parse time?

(that's PCI though and I can't really be here at the moment so over to 
someone else).

Rene.
