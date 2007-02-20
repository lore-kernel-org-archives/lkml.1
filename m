Return-Path: <linux-kernel-owner+w=401wt.eu-S964962AbXBTPOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962AbXBTPOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964976AbXBTPOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:14:23 -0500
Received: from gundega.hpl.hp.com ([192.6.19.190]:65380 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964962AbXBTPOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:14:22 -0500
Date: Tue, 20 Feb 2007 07:14:08 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] perfmon ia64: fix file/vma lifetime
Message-ID: <20070220151408.GF30911@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070220141856.GB31343@wotan.suse.de> <20070220143454.GD30911@frankl.hpl.hp.com> <20070220150844.GB5044@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220150844.GB5044@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick,

On Tue, Feb 20, 2007 at 04:08:45PM +0100, Nick Piggin wrote:
> On Tue, Feb 20, 2007 at 06:34:54AM -0800, Stephane Eranian wrote:
> > nick,
> > 
> > On Tue, Feb 20, 2007 at 03:18:56PM +0100, Nick Piggin wrote:
> > > From: Nick Piggin <npiggin@suse.de>
> > > 
> > > Perfmon associates vmalloc()ed memory with a file descriptor, and installs
> > > a vma mapping that memory. Unfortunately, the vm_file field is not filled in,
> > > so processes with mappings to that memory do not prevent the file from being
> > > closed and the memory freed. This results in use-after-free bugs and multiple
> > > freeing of pages, etc.
> > > 
> > > I saw this bug on an Altix on SLES9. Haven't reproduced upstream but it looks
> > > like the same issue is there.
> > > 
> > 
> > I think this is possible for the old perfmon v2.0 codebase that is currently in
> > mainline for IA-64.
> 
> OK, I take that as an Ack? (the patch definitely applies, I just can't
> get the Altix to boot 2.6.20 to verify it).
> 
> > I have corrected this with the multi-arch v2.3 code base 
> > available as a  kernel patch for the moment.
> 
> Not that I've looked at the code, but can I be hopeful that v2.3
> using the traditional mmap file operation to set up the vma and map
> in pages, rather than the way that v2.0 works?
> 

It does. You need an explicit mmap()  call.

-- 

-Stephane
