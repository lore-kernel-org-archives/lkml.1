Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbXKUXGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbXKUXGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 18:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbXKUXGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 18:06:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:49363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbXKUXGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 18:06:00 -0500
Subject: Re: [PATCH 3/3] PNP cleanups - Version 2 - Pass struct pnp_dev to
	pnp_clean_resource_table for cleanup reasons
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>
In-Reply-To: <20071121181318.75ceeb4d@the-village.bc.nu>
References: <1195581124.23700.262.camel@queen.suse.de>
	 <20071120180007.1ebe11a2@the-village.bc.nu> <4743372A.6030400@keyaccess.nl>
	 <20071120221812.47fb5645@the-village.bc.nu> <4743EE5E.4070301@keyaccess.nl>
	 <1195638201.23700.285.camel@queen.suse.de>
	 <20071121181318.75ceeb4d@the-village.bc.nu>
Content-Type: text/plain
Date: Thu, 22 Nov 2007 00:05:57 +0100
Message-Id: <1195686357.3760.28.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-21 at 18:13 +0000, Alan Cox wrote:
> > > in the pnp_dev. That is, the resources are tied to the device, with struct 
> > > pnp_resource_table being no more than a handy container to group them under 
> > > a single name.
> > Putting the count into struct resource does not make sense.
> 
> Can you explain that claim ?
The additional variable would only make sense for the pnp layer, or only
for the pnp resource table in the pnp layer, but struct resource is used
at much more places...
It is meant for System Memory and IO port resources in general, why
waste bytes and an additional name at all places it is used, just for
the pnp resource table?

> > The idea is to not rely on the exact pnp resource table structure and
> > abstracting this to macros. If krealloc approach works,
> > dev->res.port_resource[i].start would even still work, if not, it's
> > easier to alter the pnp resource table and the macros internally.
> 
> Externally in drivers yes. Internally in code no - it makes the code
> harder to work with.
> 
> > > Yes, I dont know how he intends to deal with this (nor, in fact, just how 
> > > dynamic things are supposed to end up to begin with) so over to Thomas.
> > Krealloc should only get used at early pnp init time, when the BIOS
> > structures are parsed. The devices shouldn't be active then...
> > A bit of a problem, as said, could be the sysfs interfaces, there it
> > must be insured krealloc is not used anymore.
> 
> I don't think its that simple but that can be dealt with one the changes
> are in place if the objects are sensibly laid out.

I hope it is, stay tuned there will come something soon...
If it's not that easy, another structure would be needed and every
dev->res.port_resource[i].start and friends need to be touched (I don't
see how this could still be resolved in a simple array then...).

    Thomas

