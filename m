Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZJUVbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZJUVbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZJUVbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:31:41 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:35134 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbZJUVbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:31:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w7GnQEh9wfuDg7CaHtjRC6cRBmESpW0PtMqWTzOulsKJ+Kxs44lohCse3G7QqpMGvZ
         qf65Ftr4U4w/QhD9vSdvHttyUXq3MoL5Rg+qU3h6W7GaVFrz9vP5UevHaKDclEhS+9ko
         j+Z+c+5EWKmkySYH+ctEejvvQhwyndPFP7YTg=
Date: Wed, 21 Oct 2009 23:31:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Message-ID: <20091021213139.GC4880@nowhere>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain> <200910200000.24574.arnd@arndb.de> <200910200008.57468.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910200008.57468.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 12:08:57AM +0200, Arnd Bergmann wrote:
> On Tuesday 20 October 2009, Arnd Bergmann wrote:
> > On Monday 19 October 2009, John Kacur wrote:
> > > How does this look? (Version 2 of the patch follows)
> > 
> > Looks good now.
> > 
> 
> A bit of background:
> 
> Doing only one of the two conversions is a correct patch as well
> of course, I just want to make sure you don't have to go through all
> the same files again once someone does a blind pushdown into the ioctl
> and llseek functions, so once you prove that a specific driver doesn't
> need the BKL, please always make sure to remove it from all three places.
> 
> I fear that the llseek part will get interesting as well, just because
> we call default_llseek instead of no_ll by default currently.
> It might be a good idea to add one of .llseek=no_llseek or 
> .llseek=generic_file_llseek in any file_operations that you prove
> to not require the BKL.
> 
> 	Arnd <><


What about a pusdown of default_lseek attribution for these
fops that don't have any llseek() (and rename it to
deprecated_default_lseek() )

Because we can probably fix these fops one by one but what
about the next drivers that will have no llseek() ?

We can't attribute default_llseek() by default anymore for
further fops that are to come.

