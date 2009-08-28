Return-Path: <linux-kernel-owner+w=401wt.eu-S1752829AbZH1VIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829AbZH1VIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZH1VIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:08:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726AbZH1VIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:08:53 -0400
Message-ID: <4A984758.5020008@redhat.com>
Date: Fri, 28 Aug 2009 14:08:40 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
CC: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
References: <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <20090828164432.GA8036@shareable.org>
In-Reply-To: <20090828164432.GA8036@shareable.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2009 09:44 AM, Jamie Lokier wrote:
> However, for userspace, there's an issue with applications which were
> compiled with an old libc and used O_SYNC.  Most of them probably
> expected O_SYNC behaviour but all they got was O_DSYNC, because Linux
> didn't do it right.

Right.  But these programs apparently can live with the broken 
semantics.  I don't worry too much about this.  If people really need 
the fixed O_SYNC semantics then let them recompile their code.


> When using a newer kernel which actually implements O_SYNC behaviour,
> I'm thinking those applications which asked for O_SYNC should get it,
> even though they're still linked with an old libc.

In general yes, but it's too expensive.  Again, existing programs expect 
the current behavior and can live with it.


> (Oh, and Ulrich: Why is there a "#define O_RSYNC O_SYNC" in the Glibc
> headers?  That doesn't make sense: O_RSYNC has nothing to do with
> writing.)

O_SYNC is a superset of O_RSYNC.  In the absence of a true O_RSYNC 
that's the next best thing.  Of course I didn't know the Linux O_SYNC is 
really O_DSYNC.  In that context the definition doesn't make sense.


> Although libc's __new_open() could have this:
>
>      /* Old kernels only look at O_DSYNC.  It's better than nothing. */
>      if (flags&  O_SYNC)
>          flags |= O_DSYNC;
>
> Imho, it's better to not do that, and instead have
>
>      #define O_SYNC          (O_DSYNC|__O_SYNC_KERNEL)

Why should it be better?  You're replacing something the compiler can do 
with zero cost with active code.


Again, these O_* constant changes are sufficient.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
