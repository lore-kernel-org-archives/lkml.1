Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbYHBFm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbYHBFm0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 01:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYHBFmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 01:42:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:43099 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYHBFmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 01:42:14 -0400
Date: Sat, 2 Aug 2008 06:42:04 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>, Thomas Renninger <trenn@suse.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature shutdown
Message-ID: <20080802054204.GB12646@srcf.ucam.org>
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain> <200807251319.12786.trenn@suse.de> <alpine.LFD.1.10.0807250948320.3884@localhost.localdomain> <alpine.LFD.1.10.0808011706350.3011@localhost.localdomain> <20080801223657.GD23558@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801223657.GD23558@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 07:36:57PM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 01 Aug 2008, Len Brown wrote:
> > It is better to expose ourselves to the known tested Windows functionality
> > -- even if it seems arbitrary, at least it is tested.  The !Windows case
> > results in running _completely_ untested BIOS code.
> 
> Actually, we should masquerade properly as the latest Windows version
> available for that machine, then.  AFAIK, Windows does not set ALL the OSI
> strings, just one.  We ARE running untested code in some BIOSes because of
> it.

The BIOSes I've tested check _OSI in order of Windows release, which is 
consistent with Windows returning OSI strings for all previous versions. 
Do you have any examples that suggest this isn't the case?

> Maybe it would be better if every ACPICA-using OS defined a
> _OSI(NotWindows), plus the relevant Windows OSI string they want to support,
> and Intel would send word that this string is to be used ONLY to disable all
> Windows bug workarounds, not to activate or deactivate any specific
> functionality?

Not all BIOSes would support this, so we'd need to support the Windows 
workarounds anyway. At that point, there's no real benefit in having 
multiple codepaths.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
