Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbXEYGB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbXEYGB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXEYGBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:01:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:32997 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbXEYGBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:01:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, David Miller <davem@davemloft.net>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
References: <200705122146.l4CLkH6q012322@fire-2.osdl.org>
	<46470209.9000502@bellsouth.net> <46470515.50000@NineX.eu.org>
	<464707F7.6080600@bellsouth.net>
	<m1irawpwy2.fsf@ebiederm.dsl.xmission.com>
	<20070513204407.7ba35010@osprey.hogchain.net>
	<4647FA38.3090108@NineX.eu.org> <46480EA5.40400@NineX.eu.org>
	<20070514053406.478bf93f@osprey.hogchain.net>
	<m1d513oddj.fsf@ebiederm.dsl.xmission.com>
	<20070514093829.377e04bc@osprey.hogchain.net>
	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>
	<20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<1180070050.8203.30.camel@concordia.ozlabs.ibm.com>
Date: Thu, 24 May 2007 23:59:47 -0600
In-Reply-To: <1180070050.8203.30.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Fri, 25 May 2007 15:14:10 +1000")
Message-ID: <m1bqg9cujw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> On Thu, 2007-05-24 at 22:19 -0600, Eric W. Biederman wrote:
>> Currently we blacklist known bad msi configurations which means we
>> keep getting MSI enabled on chipsets that either do not support MSI,
>> or MSI is implemented improperly.  Since the normal IRQ routing
>> mechanism seems to works even when MSI does not, this is a bad default
>> and causes non-functioning systems for no good reason.
>> 
>> So this patch inverts the sense of the MSI bus flag to only enable
>> MSI on known good systems.  I am seeding that list with the set of
>> chipsets with an enabled hypertransport MSI mapping capability.  Which
>> is as close as I can come to an generic MSI enable.  So for actually
>> using MSI this patch is a regression, but for just having MSI enabled
>> in the kernel by default things should just work with this patch
>> applied.
>
> I guess this is a good idea for random x86 machines. On powerpc I think
> we'll just turn it on for every bus, and let the existing per-platform
> logic decide.

Yep.  That is pretty much what I expected.

Since you already have to detect how to implement the MSI methods
you need a separate white list anyway.

Just a side note.  This only needs to be enabled for pci root
busses.

Eric
