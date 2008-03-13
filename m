Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbYCMPOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbYCMPOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 11:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYCMPOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 11:14:30 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:41233 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbYCMPO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 11:14:28 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: trenn@suse.de
Subject: Re: PNP: dynamic pnp resources
Date: Thu, 13 Mar 2008 09:17:20 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, Dave Jones <davej@codemonkey.org.uk>,
       linux-acpi@vger.kernel.org, Adam M Belay <abelay@mit.edu>,
       Zhao Yakui <yakui.zhao@intel.com>, Li Shaohua <shaohua.li@intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rene Herman <rene.herman@keyaccess.nl>
References: <20080312151452.GA4523@codemonkey.org.uk> <200803121345.21297.lenb@kernel.org> <1205409848.29877.358.camel@queen.suse.de>
In-Reply-To: <1205409848.29877.358.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803130917.21335.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 06:04:08 am Thomas Renninger wrote:
> On Wed, 2008-03-12 at 13:45 -0400, Len Brown wrote:
> > On Wednesday 12 March 2008, Dave Jones wrote:
> ...
> > Thomas worked on a patch to make resource allocation dynamic and do away
> > with these limits.  Unfortunately it was rather large and it wasn't in
> > time for the 2.6.25-rc1 window.
> 
> I had the problem that I could not test on isa systems.
> Rene Herman helped here a lot.
> There are still open issues, last state was (comment from Rene):
> ------------------------
> No. Please note we're talking about ISAPnP, not PnPBIOS. No BIOS
> involved at all.
> 
> Driver (sound/isa/cs423x/cs4236.c) furthermore does not use anything but
> the PnP layer itself. Start at snd_cs423x_pnpc_detect, which is the
> pnp .probe() method.
> 
> I'll look into providing a more extensive answer and/or test whatever
> comes in later.
> -------------------------
> I can also look at this, any hints until then are appreciated.
> 
> I also expect Bjorn was bound to other bugs and pushing things in a rush
> is not good thing anyway.
> At the end I asked for a macro problem I only had a rather ugly
> solution, didn't get an answer (IIRC I also added a compile bug in my
> suggestions) and things got stuck...
> 
> Do you want me to rework the patches, lay out where I see problems and
> give it another try to get this into -mm?

I'm sorry that I haven't responded to this.  I have some reservations,
but I wanted to try out some alternate ideas before just being a nay-
sayer because usually my grand ideas turn out to have fatal flaws.

My current grand but untested idea is that struct pnp_resource_table
is too exposed and should be better abstracted, even inside the PNP
subsystem.  Since PNP is supposed to be a way to discover platform
devices, I'm looking at the platform device interfaces for ideas.

Whatever we do, I think it has to be done incrementally to make it
reviewable and bisectable.

Bjorn
