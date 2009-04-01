Return-Path: <linux-kernel-owner+w=401wt.eu-S1758583AbZDAQv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbZDAQv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbZDAQvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:51:45 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:49420 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbZDAQvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:51:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=W2pHAjdYAE0S9OM9QNUYnMngTwPqsv4w0FlMzsmeHEasRna2pr+t24qeeQ4EtKXAzV
         9AhRp3u0QkwQJOTHGpmZNUNhoW2+vauCFxpvIRWTf2iLkNHdT8BGtYwCtfQHGAmCfhlK
         V5oq6OYBrzfDADtB+seBSHfXaormdgz+Uo8Dw=
Date: Wed, 1 Apr 2009 18:51:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Mahoney <jeffm@suse.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 00/35] Jeff's ReiserFS Patch Queue
Message-ID: <20090401165134.GA5924@nowhere>
References: <20090330180215.951354436@suse.com> <alpine.LFD.2.00.0903301236280.4093@localhost.localdomain> <20090401161657.GA13802@elte.hu> <49D39642.9070606@suse.com> <20090401163407.GE22517@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090401163407.GE22517@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 06:34:07PM +0200, Ingo Molnar wrote:
> 
> * Jeff Mahoney <jeffm@suse.com> wrote:
> 
> > -----BEGIN PGP SIGNED MESSAGE-----
> > Hash: SHA1
> > 
> > Ingo Molnar wrote:
> > > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > 
> > >>> Once this is applied, I expect reiserfs to be in deep 
> > >>> maintenance-only mode.
> > >> Heh, I hadn't expected even this.
> > > 
> > > Note, there are BKL-removal patches in the works by Frédéric 
> > > Weisbecker, for the tip:kill-the-BKL topic branch.
> > > 
> > > Reiser3 is the heaviest (and most non-trivial) BKL user amongst all 
> > > the filesystems, its BKL use is recursive and it frequently relies 
> > > on the implicit dropping of the BKL at various blocking points both 
> > > for correctness and for performance reasons.
> > > 
> > > There might be something worth posting+reviewing soon.
> > 
> > Oh interesting. I'm glad someone is working on this. I've started 
> > to several times and decided to focus my efforts on things outside 
> > of reiserfs instead. The reiserfs usage of the BKL has always been 
> > a black mark.
> 
> I'll let Frederic describe it but AFAIK the patch is working fine 
> with the BKL as a mutex and no lockdep complaints or lockups. The 
> main focus is now on finding the performance affecting spots, 
> because Frederic's main desktop is on reiserfs and he does not 
> accept a slowdown :)



Hehe :-)
No actually I would accept a tiny slowdown but I fear that the common
reiserfs users wouldn't.

I'm still working on this and once it's ready enough for an RFC patch,
I'll explain how is done the conversion to a mutex.

Stay tuned.

 
> 	Ingo

