Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbZJUVm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbZJUVm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbZJUVm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:42:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762AbZJUVm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:42:26 -0400
Date: Wed, 21 Oct 2009 23:41:07 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Arnd Bergmann <arndbergmann@googlemail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
In-Reply-To: <20091021213139.GC4880@nowhere>
Message-ID: <alpine.LFD.2.00.0910212336290.3526@localhost.localdomain>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain> <200910200000.24574.arnd@arndb.de> <200910200008.57468.arnd@arndb.de> <20091021213139.GC4880@nowhere>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Oct 2009, Frederic Weisbecker wrote:

> On Tue, Oct 20, 2009 at 12:08:57AM +0200, Arnd Bergmann wrote:
> > On Tuesday 20 October 2009, Arnd Bergmann wrote:
> > > On Monday 19 October 2009, John Kacur wrote:
> > > > How does this look? (Version 2 of the patch follows)
> > > 
> > > Looks good now.
> > > 
> > 
> > A bit of background:
> > 
> > Doing only one of the two conversions is a correct patch as well
> > of course, I just want to make sure you don't have to go through all
> > the same files again once someone does a blind pushdown into the ioctl
> > and llseek functions, so once you prove that a specific driver doesn't
> > need the BKL, please always make sure to remove it from all three places.
> > 
> > I fear that the llseek part will get interesting as well, just because
> > we call default_llseek instead of no_ll by default currently.
> > It might be a good idea to add one of .llseek=no_llseek or 
> > .llseek=generic_file_llseek in any file_operations that you prove
> > to not require the BKL.
> > 
> > 	Arnd <><
> 
> 
> What about a pusdown of default_lseek attribution for these
> fops that don't have any llseek() (and rename it to
> deprecated_default_lseek() )
> 
> Because we can probably fix these fops one by one but what
> about the next drivers that will have no llseek() ?
> 
> We can't attribute default_llseek() by default anymore for
> further fops that are to come.
> 
> 

Frederic, I think it is still useful to explicity set to no_llseek, 
drivers that don't use llseek.

I also have to agree with you, that we should no longer be using a 
default_llseek that relies on the BKL.

That is a rather large effort though. All drivers that don't specify an 
llseek function, need to either set it to no_llseek, or as you are 
proposing a deprecated default_llseek that uses the bkl.

thinking of how to start this.

John
