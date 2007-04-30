Return-Path: <linux-kernel-owner+w=401wt.eu-S1946477AbXD3RCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946477AbXD3RCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946509AbXD3RCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:02:32 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946472AbXD3RC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:02:29 -0400
Date: Mon, 30 Apr 2007 10:02:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same
 time?
Message-Id: <20070430100225.353e3030.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704300445460.17536@localhost.localdomain>
References: <Pine.LNX.4.64.0704280937060.24917@localhost.localdomain>
	<20070430001311.84d0291f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704300445460.17536@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 04:46:54 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:

> On Mon, 30 Apr 2007, Andrew Morton wrote:
> 
> > On Sat, 28 Apr 2007 09:40:39 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> >
> > >
> > >   i'd always assumed that the type flags of GFP_ATOMIC and GFP_KERNEL
> > > were mutually exclusive when it came to calling kmalloc(), at least
> > > based on everything i'd read.  so i'm not sure how to interpret the
> > > following:
> > >
> > > drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> > > drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
> > >
> > >   clarification?
> >
> > GFP_ATOMIC implies that the memory comes from the zones which
> > GFP_KERNEL also uses.  So the above usage of GFP_KERNEL is redundant
> > and should be removed.
> 
> hang on ... based on an email i just got, is that reference to
> GFP_KERNEL "redundant" or "conflicting"?  big difference there.  and
> is the proper fix to remove "GFP_KERNEL" in both cases?
> 

umm, yeah, oops.  GFP_KERNEL|GFP_ATOMIC is not a redundant combination. 
It's GFP_KERNEL plus "is able to access emergency pools".  We'd normally
represent that as GFP_KERNEL|__GFP_HIGH.

However it's questionable whether that was the intent in those two drivers.
`git-blame' might tell.

