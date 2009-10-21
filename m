Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZJUVzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZJUVzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbZJUVzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:55:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:42356 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbZJUVzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ux4Bemc38UlS77DIoC3AHgbBb/pSejzqXzRznreqaEtmYY/jcH2qGVpus5pVF9ySnm
         rFM1E2fa9bSB5HoiOMotAQuETfAbZ7uF4BpxM3QtYtubQFr+vmaaZzz51N+1IKPsAwE5
         whvavRQ+hqUGzxJGIfFUrPSBTD+7/P4OJRr38=
Date: Wed, 21 Oct 2009 23:55:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: Arnd Bergmann <arndbergmann@googlemail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] sony_pi: Remove the BKL from sonypi_misc_open
Message-ID: <20091021215553.GE4880@nowhere>
References: <alpine.LFD.2.00.0910182353480.3405@localhost.localdomain> <alpine.LFD.2.00.0910192019420.3563@localhost.localdomain> <200910200000.24574.arnd@arndb.de> <200910200008.57468.arnd@arndb.de> <20091021213139.GC4880@nowhere> <alpine.LFD.2.00.0910212336290.3526@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910212336290.3526@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 21, 2009 at 11:41:07PM +0200, John Kacur wrote:
> > What about a pusdown of default_lseek attribution for these
> > fops that don't have any llseek() (and rename it to
> > deprecated_default_lseek() )
> > 
> > Because we can probably fix these fops one by one but what
> > about the next drivers that will have no llseek() ?
> > 
> > We can't attribute default_llseek() by default anymore for
> > further fops that are to come.
> > 
> > 
> 
> Frederic, I think it is still useful to explicity set to no_llseek, 
> drivers that don't use llseek.


Yeah, I agreed.


 
> I also have to agree with you, that we should no longer be using a 
> default_llseek that relies on the BKL.
> 
> That is a rather large effort though. All drivers that don't specify an 
> llseek function, need to either set it to no_llseek, or as you are 
> proposing a deprecated default_llseek that uses the bkl.
> 
> thinking of how to start this.
> 
> John


This is a rather large effort indeed but this pushdown seems
the only way to remove default_llseek as the default llseek()
callback.

The more we wait, the more code we'll need to review and fix.

