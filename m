Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbXC0PSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbXC0PSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 11:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbXC0PSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 11:18:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59451 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890AbXC0PSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 11:18:14 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Greg KH <greg@kroah.com>, Mitch Williams <mitch.a.williams@intel.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
References: <1174951102.22190.15.camel@strongmad>
	<20070327000951.GA11555@kroah.com>
	<m14po6zupn.fsf@ebiederm.dsl.xmission.com>
	<20070327145552.GB7157@colo.lackof.org>
Date: Tue, 27 Mar 2007 09:15:03 -0600
In-Reply-To: <20070327145552.GB7157@colo.lackof.org> (Grant Grundler's message
	of "Tue, 27 Mar 2007 08:55:52 -0600")
Message-ID: <m1mz1yyayw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler <grundler@parisc-linux.org> writes:

> On Tue, Mar 27, 2007 at 07:23:16AM -0600, Eric W. Biederman wrote:
>> I guess I should add that I'm not certain that the code is exactly correct
>> there are weird differences between enable/disable and mask.
>
> My understanding was "enable" would clear (or ignore) pending interrupts
> and "unmask" would deliver pending interrupts. Disable and mask could
> in many implementations be the same thing as long as the enable/unmask
> difference was supported.

enable/disable are what are available to drivers.  When the call
enable_irq or  disable_irq.  Frequently we have code to make up
for deficiencies in the hardware irq controller implementations
here.

mask/unmask are helper functions only used by the internals of the
irq implementation, and actually are required to touch the hardware.

The problem on x86 is that an ioapic will drop interrupts that come
in while it is masked.    Thus we have to play software games not
to loose pending interrupts (i.e. leave the irq enabled until we
get a pending interrupt).

So I think you had the general drift although you had a couple of
details confused.

Eric
