Return-Path: <linux-kernel-owner+w=401wt.eu-S937058AbXHJN1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937058AbXHJN1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 09:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbXHJN1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 09:27:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:53024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696AbXHJN1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 09:27:46 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc2-mm1 -- drivers/dma/ioat_dca.c:177: error: implicit declaration of function ___cpu_physical_id___
Date: Fri, 10 Aug 2007 15:27:42 +0200
User-Agent: KMail/1.9.6
Cc: "Miles Lane" <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "shannon.nelson@intel.com" <shannon.nelson@intel.com>,
       "Luck, Tony" <tony.luck@intel.com>
References: <a44ae5cd0708090718v5dc19572k69087f170f9ba857@mail.gmail.com> <20070809115258.5372f76e.akpm@linux-foundation.org>
In-Reply-To: <20070809115258.5372f76e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708101527.42628.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 August 2007 20:52:58 Andrew Morton wrote:
> On Thu, 9 Aug 2007 10:18:15 -0400
> "Miles Lane" <miles.lane@gmail.com> wrote:
> 
> >   CC      drivers/dma/ioat_dca.o
> > drivers/dma/ioat_dca.c: In function 'ioat_dca_get_tag':
> > drivers/dma/ioat_dca.c:177: error: implicit declaration of function
> > 'cpu_physical_id'
> 
> Looks like cpu_physical_id() doesn't get implemented if CONFIG_SMP=n.
> 
> Either ioat needs to stop using cpu_physical_id() if SMP=n, or the
> supported architectures (i386, x86_64, ia64) should provide a non-SMP
> version of cpu_physical_id().  Preferably the latter, I'd say.


It doesn't make much sense in smp.h because there is not really
a concept of physical id on most architectures i expect. Better 
to put it into the individual asm files.

-Andi

