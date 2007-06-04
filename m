Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbXFDElP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbXFDElP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 00:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXFDElB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 00:41:01 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52022 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbXFDElA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 00:41:00 -0400
Date: Mon, 4 Jun 2007 10:10:41 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: A kexec approach to hibernation
Message-ID: <20070604044041.GB10206@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <878xb3l888.fsf@jbms.ath.cx> <200706012339.06379.rjw@sisk.pl> <87zm3j9usv.fsf@jbms.ath.cx> <200706020114.37245.rjw@sisk.pl> <87odjz9qo9.fsf@jbms.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87odjz9qo9.fsf@jbms.ath.cx>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 07:54:30PM -0400, Jeremy Maitin-Shepard wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Saturday, 2 June 2007 00:25, Jeremy Maitin-Shepard wrote:
> 
> [snip]
> 
> >> Just before jumping into the new kernel, with interrupts disabled, the
> >> old kernel could either prepare a data structure that specifies what
> >> pages are allocated, or alternatively simply provide a pointer to the
> >> relevant data structure in the old kernel.
> 
> > But for this purpose the old kernel will actually need to do what is currently
> > done in swsusp while the image is being created (the only difference is that
> > we allocate memory in the process, but that's a detail only).
> 
> Okay, but creating a list of pages should be extremely easy.
> Alternatively, with the "save kernel" might be able to read the existing
> data structures directly.
> 

Can't we do it Kdump way? Kdump creates ELF headers and stores these in 
memory. Address of these elf headers is passed to second kernel through
command line parameter. These ELF headers contain the information regarding
what memory areas need to be captured by the second kernel.

Can't we adopt similar raw approach for hibernation? Reserve a memory
area for second kernel (This is not used by first kernel). During hibernation,
load second kernel in reserved memory area which will also determine
what physical memory needs to be saved (possibly reading /proc/iomem) and
create ELF headers and then second kernel can parse these headers and save
the memory. The output file can possibly be and ELF image again so that
restoring back becomes easier.

I am just thinking that do we have to create a list of pages etc? Can't we
just copy the raw memory to disk and restore it back. Information regarding
where a chunk of memory should go back will be provided by the ELF header.

One fall side would be that problem of reserving a memory area constantly
and this memory area is currently reserved at first kernel boot time. Can we
somehow make this reservation dynamic? Something like using hugepage support
so that we can allocate big chunks of contiguous physical memory from user
space (32MB or 64MB) at run time.

Thanks
Vivek
