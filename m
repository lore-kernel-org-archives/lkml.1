Return-Path: <linux-kernel-owner+w=401wt.eu-S965963AbXC2FYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965963AbXC2FYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 01:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964883AbXC2FYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 01:24:35 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59036 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965963AbXC2FYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 01:24:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
Subject: Re: [PATCH 14/21] MSI: Use a list instead of the custom link structure
References: <20070322105343.3B358DDF6D@ozlabs.org>
	<m13b3pswx2.fsf@ebiederm.dsl.xmission.com>
	<1175144609.16660.33.camel@concordia.ozlabs.ibm.com>
Date: Wed, 28 Mar 2007 23:24:00 -0600
In-Reply-To: <1175144609.16660.33.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Thu, 29 Mar 2007 15:03:29 +1000")
Message-ID: <m13b3omxlb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

>
> I thought about doing it in the MSI enable methods, but I think it
> really belongs in the (nonexistant) routine that allocs and sets up a
> pci_dev.

I agree that would be a good place for it as well.

> I think it's pretty dicy to be passing around a pci_dev with an
> uninitialised msi_list. Even if currently no code outside the MSI enable
> methods looks at it, I think we're asking for bugs in the future.

Reasonable.

> So I'll do a patch which adds alloc_pci_dev(), update the callers, and
> then put the msi_list initialisation in there.

Sounds good.  That will allow us to initialize all of the fields in struct
pci_dev to a default value in one place.

Eric
