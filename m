Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbXC3CGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbXC3CGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 22:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbXC3CGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 22:06:47 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:24060 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbXC3CGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 22:06:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=VlKCqw52S6qc6W2I85QYj23IM9b/MbWuolaMjCe0/eo6BqbN9rsq/bXOnKe5/xER1tL2QyvHItrvEM/AW27T6tvImrwRaxoKTu+y0MxyvoefDOZDZLDSNmmmEJEA+l10TAtsjpmhcz9Wdk37vVLrHsCJVvOCXec+We1MUmRRvs4=
Message-ID: <75b66ecd0703291906q265f9cc7g486cf65484ba8393@mail.gmail.com>
Date: Thu, 29 Mar 2007 22:06:41 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch] queued spinlocks (i386)
Cc: "Oleg Nesterov" <oleg@tv-sign.ru>, "Nick Piggin" <npiggin@suse.de>,
       "Ravikiran G Thirumalai" <kiran@scalex86.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Nikita Danilov" <nikita@clusterfs.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703291215440.1199@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070325155407.GA497@tv-sign.ru>
	 <20070328070459.GC12508@wotan.suse.de>
	 <20070329184213.GA83@tv-sign.ru>
	 <Pine.LNX.4.64.0703291215440.1199@alien.or.mcafeemobile.com>
X-Google-Sender-Auth: 2674c48ccdb91eec
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Thu, 29 Mar 2007, Oleg Nesterov wrote:
>
> > On 03/28, Nick Piggin wrote:
> > >
> > > Well with my queued spinlocks, all that lockbreak stuff can just come out
> > > of the spin_lock, break_lock out of the spinlock structure, and
> > > need_lockbreak just becomes (lock->qhead - lock->qtail > 1).
> >
> > Q: queued spinlocks are not CONFIG_PREEMPT friendly,
>
> Why? Is CONFIG_PREEMPT friendly to anyone? :)

Until someone fixes all the places in the kernel where scheduling can
be held off for tens of milliseconds, CONFIG_PREEMPT will be an
absolute requirement for many applications like audio and gaming.

Many of these were fixed a while back during early -rt development but
at some point the process stalled as the remaining cases were too hard
to fix...

Lee
