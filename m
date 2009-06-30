Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZF3Wlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZF3Wlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbZF3Wln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:41:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:51101 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbZF3Wlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:41:42 -0400
Date: Tue, 30 Jun 2009 15:30:40 -0700
From: Greg KH <gregkh@suse.de>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Kurt Garloff <garloff@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
Message-ID: <20090630223040.GA3802@suse.de>
References: <20090624213211.GA11291@kroah.com> <alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 11:27:57PM +0100, Maciej W. Rozycki wrote:
> On Wed, 24 Jun 2009, Greg KH wrote:
> 
> > This patch introduces a sysctl /proc/sys/kernel/panic_on_io_nmi, which
> > defaults to 0 (off).
> > 
> > When enabled, the kernel panics when the kernel receives an NMI caused
> > by an IO error.
> > 
> > The IO error triggered NMI indicates a serious system condition, which
> > could result in IO data corruption. Rather than contiuing, panicing and
> > dumping might be a better choice, so one can figure out what's causing
> > the IO error.
> > 
> > This could be especially important to companies running IO intensive
> > applications where corruption must be avoided, e.g. a banks databases.
> 
>  These days an IOCK NMI typically happens in response to a PCI SERR -- it 
> may be useful to traverse PCI buses to find the offender and dump this 
> information on this occasion too.  The south bridge may have additional 
> status too.

Sure, that would be great to have.  Care to make a patch?  :)

thanks,

greg k-h
