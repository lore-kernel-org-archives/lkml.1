Return-Path: <linux-kernel-owner+w=401wt.eu-S1752652AbXC3Tr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbXC3Tr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 15:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbXC3Tr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 15:47:57 -0400
Received: from smtp.osdl.org ([65.172.181.24]:50258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbXC3Tr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 15:47:56 -0400
Date: Fri, 30 Mar 2007 12:47:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Mitch Williams <mitch.a.williams@intel.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, auke-jan.h.kok@intel.com
Subject: Re: [PATCH 2.6.21-rc5] Flush MSI-X table writes (rev 3)
Message-Id: <20070330124747.f20c9eb0.akpm@linux-foundation.org>
In-Reply-To: <m1irciime5.fsf@ebiederm.dsl.xmission.com>
References: <1175280848.17652.5.camel@strongmad>
	<m1irciime5.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 13:04:02 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Mitch Williams <mitch.a.williams@intel.com> writes:
> 
> > This patch fixes a kernel bug which is triggered when using the
> > irqbalance daemon with MSI-X hardware.
> >
> > Because both MSI-X interrupt messages and MSI-X table writes are posted,
> > it's possible for them to cross while in-flight.  This results in
> > interrupts being received long after the kernel thinks they're disabled,
> > and in interrupts being sent to stale vectors after rebalancing.
> >
> > This patch performs a read flush after writes to the MSI-X table for
> > mask and unmask operations.  Since the SMP affinity is set while
> > the interrupt is masked, and since it's unmasked immediately after,
> > no additional flushes are required in the various affinity setting
> > routines.
> >
> > This patch has been validated with (unreleased) network hardware which
> > uses MSI-X.
> >
> > Revised with input from Eric Biederman.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

Did we end up deciding whether this is (needed*safe) enough for 2.6.21?
