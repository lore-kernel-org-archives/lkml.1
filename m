Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522AbZJKXLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbZJKXLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZJKXLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:11:19 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:53198 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbZJKXLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:11:17 -0400
Date: Sun, 11 Oct 2009 17:10:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Brad Spengler <spender@grsecurity.net>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] pci: fix crash about old IA64 about pci_cfg_space_size
Message-ID: <20091011231039.GB7545@parisc-linux.org>
References: <20091011074531.GA12357@grsecurity.net> <4AD1AE0D.1030007@kernel.org> <4AD24766.7050205@kernel.org> <20091011213245.GC18513@grsecurity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011213245.GC18513@grsecurity.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 05:32:45PM -0400, Brad Spengler wrote:
> > Brad reported that his SGI 750 (Itanium 1) will crash from 2.6.26, and 
> > bisected
> 
> 2.6.26 to 2.6.29 are fine -- the commit responsible was introduced in 2.6.30, 
> so only those kernels >= 2.6.30 exhibit the problem.  For searching 
> purposes (so that Debian unstable etc can backport the fix to their 
> 2.6.30 kernel), the error causing the panic at boot was:
> 
> General Exception: IA-64 Reserved Register/Field fault (data access) 48
> 
> and occurred a few lines after "ACPI: PCI Root Bridge [PCI0] (0000:00)"

The SAL config code _used_ to use SAL 3.2 if the SAL revision were >3.1.
Unfortunately, this broke a few HP machines where HP were reporting
a SAL revision in the 60-80 range (a bug fixed in later firmware, but
some people had prototype machines which couldn't be upgraded to newer
firmware ...)

So how about we go back to adding that check ... this does require that
SGI's 750 machine reports its SAL revision correctly.  Could you send
the dmesg?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
