Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab0CKRsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:48:25 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:56066 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab0CKRsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:48:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fSYcOHzFQIGxSM/DPmE5TTdVUpysrZihLTolablBBboD/Cr2f6BOtKfxvrVjyotHfr
         6SORlL90eUdtMQrRivbePh7S63f/z0qRXlKJ8//8tyi+csOw6kB9wtSgoR2NW9o8rZPg
         eJpQbDUCmKsbBnQXnBqeU51nP8Bm5OAtyswxY=
Date: Thu, 11 Mar 2010 19:48:22 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
Message-ID: <20100311174821.GA5123@x200>
References: <4B990496.4020002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B990496.4020002@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 11:56:22PM +0900, Tejun Heo wrote:
> Lee Schermerhorn was trying to use percpu from slab.h and ran into a
> dependency loop.  percpu.h was using slab.h for UP inline
> implementation which isn't a big deal in itself but it turns out that
> percpu.h ends up being included everywhere via module.h and sched.h.
> So, removing that implicit inclusion breaks a lot of files.
> 
> The following git tree contains trial conversion on x86_64.
> allmodconfig builds fine on it but a lot of other archs are likely to
> break although fixing them up shouldn't be too hard.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git review-remove-implied-slab-inclusion
> 
> This can be solved much easier by moving some of the stuff that's
> necessary for slab.h from percpu.h into percpu-defs.h which originally
> got separated so that it can be used by asm/percpu.h but it's hackish
> and for longer term, it would be better to have slab.h explicitly
> included where necessary.
> 
> So, what do you guys think?  Probably-the-right-thing-to-do >544 file
> patch or somewhat-ugly-but-let's-worry-about-it-tommorrow two file
> patch?

You can include slab.h only for UP case.

Since everyone tests on allmodconfig which has SMP=y, configuration
will be more strict wrt headers, and compile breakages amount
negligible.
