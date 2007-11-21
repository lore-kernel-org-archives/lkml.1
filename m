Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbXKUSPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbXKUSPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:15:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXKUSPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:15:41 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56175 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751676AbXKUSPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:15:40 -0500
Date: Wed, 21 Nov 2007 18:13:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: trenn@suse.de
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>
Subject: Re: [PATCH 3/3] PNP cleanups - Version 2 - Pass struct pnp_dev to
 pnp_clean_resource_table for cleanup reasons
Message-ID: <20071121181318.75ceeb4d@the-village.bc.nu>
In-Reply-To: <1195638201.23700.285.camel@queen.suse.de>
References: <1195581124.23700.262.camel@queen.suse.de>
	<20071120180007.1ebe11a2@the-village.bc.nu>
	<4743372A.6030400@keyaccess.nl>
	<20071120221812.47fb5645@the-village.bc.nu>
	<4743EE5E.4070301@keyaccess.nl>
	<1195638201.23700.285.camel@queen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > in the pnp_dev. That is, the resources are tied to the device, with struct 
> > pnp_resource_table being no more than a handy container to group them under 
> > a single name.
> Putting the count into struct resource does not make sense.

Can you explain that claim ?

> The idea is to not rely on the exact pnp resource table structure and
> abstracting this to macros. If krealloc approach works,
> dev->res.port_resource[i].start would even still work, if not, it's
> easier to alter the pnp resource table and the macros internally.

Externally in drivers yes. Internally in code no - it makes the code
harder to work with.

> > Yes, I dont know how he intends to deal with this (nor, in fact, just how 
> > dynamic things are supposed to end up to begin with) so over to Thomas.
> Krealloc should only get used at early pnp init time, when the BIOS
> structures are parsed. The devices shouldn't be active then...
> A bit of a problem, as said, could be the sysfs interfaces, there it
> must be insured krealloc is not used anymore.

I don't think its that simple but that can be dealt with one the changes
are in place if the objects are sensibly laid out.

Alan
