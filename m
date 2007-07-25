Return-Path: <linux-kernel-owner+w=401wt.eu-S1761526AbXGYGJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761526AbXGYGJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753011AbXGYGJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:09:04 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:53878 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbXGYGJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:09:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=D1j+ppGSfZLaPpxGBjr87XXd34h1KXso4CWjCyhRFykav1qRxiDmQ600omEwVNlPiuvqOVBRqSO82ydBBhb5qJm8UbH4wmACwmG/iJfP+2HvAPk0RBG79AhmB5KgKnt6hamXbFPAzhG6gS/Nhlk+adK8S1XF6qhciUdDbf0BY9M=
Message-ID: <b21f8390707242309r4a925737p777e507e473df1ab@mail.gmail.com>
Date: Wed, 25 Jul 2007 16:09:01 +1000
From: "Matthew Hawkins" <darthmdh@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Jesper Juhl" <jesper.juhl@gmail.com>,
       linux-kernel@vger.kernel.org, "ck list" <ck@vds.kolivas.org>,
       linux-mm@kvack.org, "Paul Jackson" <pj@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <46A6CC56.6040307@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <200707102015.44004.kernel@kolivas.org>
	 <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	 <46A57068.3070701@yahoo.com.au>
	 <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com>
	 <46A58B49.3050508@yahoo.com.au>
	 <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com>
	 <46A6CC56.6040307@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> I'm not saying that we can't try to tackle that problem, but first of
> all you have a really nice narrow problem where updatedb seems to be
> causing the kernel to completely do the wrong thing. So we start on
> that.

updatedb isn't the only problem, its just an obvious one.  I like the
idea of looking into the vfs for this and other one-shot applications
(rather than looking at updatedb itself specifically)

Many modern applications have a lot of open file handles.  For
example, I just fired up my usual audio player and sys/fs/file-nr
showed another 600 open files (funnily enough, I have roughly that
many audio files :)  I'm not exactly sure what happens when this one
gets swapped out for whatever reason (firefox/java/vmware/etc chews
ram, updatedb, whatever) but I'm fairly confident what happens between
kswapd and the vfs and whatever else we're caching is not optimal come
time for this process to context-switch back in.  We're not running a
highly-optimised number-crunching scientific app on desktops, we're
running a full herd of poorly-coded hogs simultaneously through
smaller pens.

I don't think anyone is trying to claim that swap prefetch is the be
all and end all of this problem's solution, however without it the
effects are an order of magnitude worse (I've cited numbers elsewhere,
as have several others); its relatively non-intrusive (600+ lines of
the 755 changed ones are self-contained), is compile and runtime
selectable, and still has a maintainer now that Con has retired.  If
there was a better solution, it should have been developed sometime in
the past 23 months that swap prefetch has addressed it.  That's how we
got rmap versus aa, and so on.  But nobody chose to do so, and
continuing to hold out on merging it on the promise of vapourware is
ridiculous.  That has never been the way linux kernel development has
operated.

-- 
Matt
