Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbXC1GFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbXC1GFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 02:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbXC1GFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 02:05:31 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51821 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbXC1GFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 02:05:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       <daniel.e.wolstenholme@intel.com>
Subject: Re: [PATCH 12/21] MSI: Leave MSI-X masking to the irq chip
References: <20070322105341.BC584DDF3E@ozlabs.org>
Date: Wed, 28 Mar 2007 00:05:00 -0600
In-Reply-To: <20070322105341.BC584DDF3E@ozlabs.org> (Michael Ellerman's
	message of "Thu, 22 Mar 2007 21:51:40 +1100")
Message-ID: <m17it1sy2b.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> When freeing an MSI-X in msi_free_irq(), the irq must have already been
> free'd (otherwise we'd hit the BUG_ON), and in the process will have been
> masked or otherwise disabled by the irq chip methods. So there's no
> reason to mask again in the MSI code.

Given the recent discussion about the problems of lazy disable I don't believe
the premise of this patch.

Although I suspect the proper solution is to fix free_irq to call ->mask instead
of disable.  If an irq fires in the forest and no one is listening who cares.

After which point this patch would make sense again.

Eric
