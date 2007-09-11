Return-Path: <linux-kernel-owner+w=401wt.eu-S1763052AbXIKKBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763052AbXIKKBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760489AbXIKKBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:01:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:59304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757590AbXIKKBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:01:11 -0400
Date: Tue, 11 Sep 2007 12:01:10 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: linux-arch@vger.kernel.org, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/5] Extended crashkernel command line
Message-ID: <20070911100110.GB31038@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	linux-arch@vger.kernel.org, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <20070909083914.065380136@strauss.suse.de> <20070909083914.488571169@strauss.suse.de> <20070911061522.GD5053@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911061522.GD5053@in.ibm.com>
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal <vgoyal@in.ibm.com> [2007-09-11 08:15]:
> 
> "offset" seems to be optional in the new syntax. What happens if user does
> not specify offset. I think crash_base will be set to zero and system will
> try to reserve x amount of memory start at zero? That would fail?

That's handled in the architecture specific code -- because it's
different on each architecture and the architecture specific code does
memory reservation. IA64 already can handle this case (on IA64,
specifying 0 is the same than leaving out the base address, and that's
why I wanted to keep that semantics). I think it doesn't also make
sense on i386/x86_64 to choose 0 as real base address, because the
value below 1 MB is special for booting ...

> I think we should add some intelligence for automatic selection of "offset"
> if user has not specified one. Automatically choose a chunk of free memory.
> This takes away the headache from user for selecting a right place. In fact
> one "offset" might not be valid for all the systems. I remember, somebody
> had reported that ACPI tables were mapped lower in the address space and
> reserving memory for kdump had failed.

I think you're right -- with the relocatable kernel it makes sense to
have the kernel to decide where to reservate that memory. But that's
beyond of the scope of that patch series -- however, I can come up
with a solution, after that patch has been finished.


Thanks,
   Bernhard

