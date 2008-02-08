Return-Path: <linux-kernel-owner+w=401wt.eu-S935628AbYBHUki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628AbYBHUki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933336AbYBHUkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:40:13 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:37135 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933962AbYBHUkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:40:10 -0500
From: Konrad Rzeszutek <konrad@darnok.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] Add iSCSI iBFT support (v0.4.6)
Date: Fri, 8 Feb 2008 15:37:17 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, michaelc@cs.wisc.edu, dwm@enoyolf.org,
       darnok@68k.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com,
       arjan@infradead.org, Andy Whitcroft <apw@shadowen.org>
References: <20080130213700.GA28529@andromeda.dapyr.net> <1201911489.3134.79.camel@localhost.localdomain>
In-Reply-To: <1201911489.3134.79.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802081537.33767.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 19:18:09 James Bottomley wrote:
> On Wed, 2008-01-30 at 17:37 -0400, Konrad Rzeszutek wrote:
> > This patch (v0.4.6) adds

> Some pieces of the patch are obviously wrong:  find_ibft() shouldn't be
> in ibft_init ... if ibft_phys was zero, it means the bootmem reservation
> wasn't done and you shouldn't be poking about in memory which has likely
> now been overwritten.
Fixed.
>
> Also, why is ibft_phys the global variable you pass?  You never actually
> want to use the physical address, what you always end up using is the
> kernel virtual address.
>
> I'd simply use the ibft variable to point to the virtual address of the
> ibft or null if not found, then you can throw out all the phys_to_virt()
> calls.
Fixed.
>
> Also, move the reserve_bootmem into the ibft_find routines and ensure
> they're only called once on boot.  Refuse to attach the ibft driver if
> the virtual pointer ibft is null.

James,

Thanks for your review. If you wouldn't mind, can you take a look
at the version 0.4.7 (http://lkml.org/lkml/2008/2/8/350) which has your 
suggestions incorporated.

Thanks again.
