Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbXFOPbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbXFOPbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbXFOPbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:31:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:39527 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbXFOPbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EKvTzTudwqTC++a/XDt3SFdqFNdevyN/FeMKzA/4afCasE/wp86bqll5R8LRo2McyKpAX1MZxbDdgW4KcNhmRdDmp0GywEPfNfhMKLM9ZdYubRyR5iC8Q9nG3ZDFWLdIA9/hgi45m2D59VyfYD35DQZByrTf13jrFWvCTq2Ba9A=
Message-ID: <9a8748490706150831o7e8de78cq9f612564d1c5ddb0@mail.gmail.com>
Date: Fri, 15 Jun 2007 17:31:37 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [-mm patch] #if 0 mm/backing-dev.c:congestion_wait_interruptible()
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070612225701.GY3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070612110733.GU3588@stusta.de>
	 <9a8748490706120540p29d00d3cg9d8a4def0d57b783@mail.gmail.com>
	 <20070612225701.GY3588@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Tue, Jun 12, 2007 at 02:40:06PM +0200, Jesper Juhl wrote:
> > On 12/06/07, Adrian Bunk <bunk@stusta.de> wrote:
> >> congestion_wait_interruptible() is no longer used.
> >>
> > Remind me again why it is that we add all these  #if 0  blocks instead
> > of simply removing the unused code?
> >
> > It's just creating a janitorial task to go and remove all the #if 0
> > bits at a later time, seems like pointless churn to me. If the code
> > needs to go, let's just get rid of it in one go instead of two.
>
> The #if 0 also handles all "I want to use this code in 6 months"
> comments that might come (and in some rare cases it even gets used
> later).
>
Well, if it is going to be used in 6 months it's just as easy to add
the code back at that point as it is to remove the  #if 0  bits. Or
simply not remove it in the first place - if it's going to be used in
6 months, all we gain from  #if 0  is slightly smaller binary size for
6 months ... a bit pointless don't you think?

> My primary intention is to remove dead code from bloating the kernel
> image, and this way the probability of patch acceptance is higher.
>
I have no objections to removing dead code. That's a fine objective.
My only concern is that eventually we'll be left with a mountain of
code inside  #if 0  that noone ever cleans up.

I guess I could start grep'ing the surce for "#if 0" at regular
intervals and removing any instances that were added >6months ago...
Something inside me just screams that I shouldn't have to :-)

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
