Return-Path: <linux-kernel-owner+w=401wt.eu-S932224AbXEADz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbXEADz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 23:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXEADz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 23:55:58 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60762 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030515AbXEADz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 23:55:56 -0400
Date: Tue, 1 May 2007 09:25:39 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Andi Kleen <ak@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       Jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org,
       Helge Hafting <helgehaf@aitel.hist.no>, Horms <horms@verge.net.au>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] x86_64: Reflect the relocatability of the kernel in the ELF header.
Message-ID: <20070501035539.GA15472@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <m1slah6gm0.fsf@ebiederm.dsl.xmission.com> <200704301717.08230.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704301717.08230.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 05:17:07PM +0200, Andi Kleen wrote:
> On Monday 30 April 2007 17:12:39 Eric W. Biederman wrote:
> > 
> > Currently because vmlinux does not reflect that the kernel is relocatable
> > we still have to support CONFIG_PHYSICAL_START.  So this patch adds a small
> > c program to do what we cannot do with a linker script set the elf header
> > type to ET_DYN.
> > 
> > Since last time I have fixed the type to be in my code ET_DYN (oops),
> > and verified this works with kexec.  I realized while testing that we
> > don't have anyway of identifying a kernel vmlinux as linux so we
> > probably want to add an ELF note but that will be another patch.
> 
> The patch is ok for me, but does it pass Vivek's usual testing?

I am facing one issue with this patch. gdb can not analyze the
resulting kernel core file. Looks like gdb treats vmlinux differently if
ELF header type is "ET_DYN". It reads the symbol values incorrectly.

For example, symbol value of "panic_timeout" is 0xffffffff808a1fa8 but
gdb somehow things that it is 0xffffffff008aaebf. Looks like it is
performing some relocation.

I am using GNU gdb Red Hat Linux (6.5-5.fc6rh).

Thanks
Vivek
