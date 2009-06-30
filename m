Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbZF3WWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbZF3WWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbZF3WWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:22:46 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:33756 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbZF3WWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:22:46 -0400
Date: Tue, 30 Jun 2009 23:27:57 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Greg KH <gregkh@suse.de>
cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Kurt Garloff <garloff@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
In-Reply-To: <20090624213211.GA11291@kroah.com>
Message-ID: <alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org>
References: <20090624213211.GA11291@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Greg KH wrote:

> This patch introduces a sysctl /proc/sys/kernel/panic_on_io_nmi, which
> defaults to 0 (off).
> 
> When enabled, the kernel panics when the kernel receives an NMI caused
> by an IO error.
> 
> The IO error triggered NMI indicates a serious system condition, which
> could result in IO data corruption. Rather than contiuing, panicing and
> dumping might be a better choice, so one can figure out what's causing
> the IO error.
> 
> This could be especially important to companies running IO intensive
> applications where corruption must be avoided, e.g. a banks databases.

 These days an IOCK NMI typically happens in response to a PCI SERR -- it 
may be useful to traverse PCI buses to find the offender and dump this 
information on this occasion too.  The south bridge may have additional 
status too.

  Maciej
