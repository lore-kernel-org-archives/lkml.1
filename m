Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbZEAMze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbZEAMze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 08:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbZEAMzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 08:55:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:6018 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbZEAMzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 08:55:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bfHRIV2aLGmgsYAsqvbBlGjVMszuq3jsUW8oQoFcNrD+x0l+SkqJc7qVjDYSSRRSrh
         9W7AEuanJuCrqMY5kCeL4KgzsNofCufM2SP/QiYgeqvd4opxG1WFBPa7guUS1sRltJWe
         mKlTQFAVkWWNY7o30BtpUnRYYIA36jTXjQyZc=
Date: Fri, 1 May 2009 16:56:05 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: checkpoint/restart: taking refcounts on kernel objects
Message-ID: <20090501125605.GA10942@x200.localdomain>
References: <20090410023539.GK27788@x200.localdomain> <20090413214701.GA24509@us.ibm.com> <20090414152752.GC27461@x200.localdomain> <20090414154139.GA8085@us.ibm.com> <20090414170419.GD27923@x200.localdomain> <1239729800.32604.92.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239729800.32604.92.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 10:23:20AM -0700, Dave Hansen wrote:
> On Tue, 2009-04-14 at 21:04 +0400, Alexey Dobriyan wrote:
> > > Right while I have opinions on some things in this list, I didn't
> > > mean to imply positions on these items.  My question was:  are
> > > there are differences you want to call out?
> > 
> > Sorry? "none needed" is relevant to only item 3. If tasks don't
> > dissapear during checkpoint, why would netns dissapear.
> > Taking refcount on checkpoint(2) is likely unneeded.
> > 
> > But it's low-level detail anyway.
> 
> I guess it is a matter of whether we consider a task that gets unfrozen
> a kernel bug or not.  If we don't take refcounts and we do reference an
> object that disappears, then we *certainly* have a kernel bug that can
> crash the kernel.  If we take refcounts, we at least limit the ways in
> which the kernel can crash when something screwy happens.
> 
> On the other hand, the objhash is a kinda weird way to do it.  Taking
> and releasing arbitrary refcounts on arbitrary kernel objects one level
> too much of abstraction for me.

Hm, I take this objection back (refcounts at checkpoint(2) time).
It's easier and safer to always grab it when putting checkpointed object
to hash/list/whatever to maintain refcount correct.
On context destroy, every object is put regardless of whether it's
checkpointing or restarting.
