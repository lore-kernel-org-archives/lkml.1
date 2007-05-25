Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbXEYGkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbXEYGkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXEYGk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:40:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50315
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752045AbXEYGk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:40:28 -0400
Date: Thu, 24 May 2007 23:40:31 -0700 (PDT)
Message-Id: <20070524.234031.78709215.davem@davemloft.net>
To: michael@ellerman.id.au
Cc: ebiederm@xmission.com, gregkh@suse.de, jacliburn@bellsouth.net,
       ninex@NineX.eu.org, akpm@linux-foundation.org, ak@suse.de, ninex@o2.pl,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       tony.luck@intel.com
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1180070050.8203.30.camel@concordia.ozlabs.ibm.com>
References: <20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<1180070050.8203.30.camel@concordia.ozlabs.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>
Date: Fri, 25 May 2007 15:14:10 +1000

> On Thu, 2007-05-24 at 22:19 -0600, Eric W. Biederman wrote:
> > Currently we blacklist known bad msi configurations which means we
> > keep getting MSI enabled on chipsets that either do not support MSI,
> > or MSI is implemented improperly.  Since the normal IRQ routing
> > mechanism seems to works even when MSI does not, this is a bad default
> > and causes non-functioning systems for no good reason.
> > 
> > So this patch inverts the sense of the MSI bus flag to only enable
> > MSI on known good systems.  I am seeding that list with the set of
> > chipsets with an enabled hypertransport MSI mapping capability.  Which
> > is as close as I can come to an generic MSI enable.  So for actually
> > using MSI this patch is a regression, but for just having MSI enabled
> > in the kernel by default things should just work with this patch
> > applied.
> 
> I guess this is a good idea for random x86 machines. On powerpc I think
> we'll just turn it on for every bus, and let the existing per-platform
> logic decide.

I think I'll turn it on always on sparc64.
