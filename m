Return-Path: <linux-kernel-owner+w=401wt.eu-S964981AbXBTPIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981AbXBTPIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964983AbXBTPIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:08:48 -0500
Received: from mx1.suse.de ([195.135.220.2]:33588 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964981AbXBTPIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:08:47 -0500
Date: Tue, 20 Feb 2007 16:08:45 +0100
From: Nick Piggin <npiggin@suse.de>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] perfmon ia64: fix file/vma lifetime
Message-ID: <20070220150844.GB5044@wotan.suse.de>
References: <20070220141856.GB31343@wotan.suse.de> <20070220143454.GD30911@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220143454.GD30911@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 06:34:54AM -0800, Stephane Eranian wrote:
> nick,
> 
> On Tue, Feb 20, 2007 at 03:18:56PM +0100, Nick Piggin wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > 
> > Perfmon associates vmalloc()ed memory with a file descriptor, and installs
> > a vma mapping that memory. Unfortunately, the vm_file field is not filled in,
> > so processes with mappings to that memory do not prevent the file from being
> > closed and the memory freed. This results in use-after-free bugs and multiple
> > freeing of pages, etc.
> > 
> > I saw this bug on an Altix on SLES9. Haven't reproduced upstream but it looks
> > like the same issue is there.
> > 
> 
> I think this is possible for the old perfmon v2.0 codebase that is currently in
> mainline for IA-64.

OK, I take that as an Ack? (the patch definitely applies, I just can't
get the Altix to boot 2.6.20 to verify it).

> I have corrected this with the multi-arch v2.3 code base 
> available as a  kernel patch for the moment.

Not that I've looked at the code, but can I be hopeful that v2.3
using the traditional mmap file operation to set up the vma and map
in pages, rather than the way that v2.0 works?

Or is there some particular reason why you avoided that?

Thanks,
Nick

