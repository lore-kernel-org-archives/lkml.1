Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZECQfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZECQfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 12:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbZECQfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 12:35:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35409 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbZECQfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 12:35:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 3/4] PM/Hibernate: Use memory allocations to free memory (rev. 2)
Date: Sun, 3 May 2009 18:35:06 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <alpine.LFD.2.01.0905021958480.4983@localhost.localdomain> <20090503093659.GA10278@elf.ucw.cz>
In-Reply-To: <20090503093659.GA10278@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905031835.06928.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 May 2009, Pavel Machek wrote:
> Hi!

Hi,

> > > Remove the shrinking of memory from the suspend-to-RAM code, where it is 
> > > not really necessary.
> > 
> > Hmm. Shouldn't we do this _regardless_?
> > 
> > IOW, shouldn't this be a totally separate patch? It seems to be left-over 
> > from when we shared the same code-paths, and before the split of the STR 
> > and hibernate code?
> > 
> > IOW, shouldn't the very _first_ patch just be this part? That code doesn't 
> > make any sense anyway (that FREE_PAGE_NUMBER really _is_ totally 
> > arbitrary).
> > 
> > This part seems to be totally independent of all the other parts in your 
> > patch-series. No?
> 
> I'm not sure this one is a good idea: drivers will need to allocate
> memory during suspend/resume, and when processes are frozen/disk
> driver is suspended, normal memory management will no longer work.
> 
> So, freeing 4M of memory before starting suspend seems like a good
> idea. That way those small alocations will not fail.

I don't think we've ever had problems with the drivers having too little
memory to suspend.

I'm opting for removing this code and seeing if that leads to any regressions.
If it does, we can still get some free memory by allocating and releasing it.

Thanks,
Rafael
