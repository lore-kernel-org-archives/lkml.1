Return-Path: <linux-kernel-owner+w=401wt.eu-S1756304AbZBKByV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304AbZBKByV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbZBKByM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:54:12 -0500
Received: from smtp-out.google.com ([216.239.45.13]:12058 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbZBKByL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:54:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=nkQvTv6NAcrzMksQpIdrZPoOfzlEEQFajrP/517GTPrTsPhYdAcF/Yw2drBpCfiwx
	6GWTp+gCmXJ9wtRonwI5Q==
MIME-Version: 1.0
In-Reply-To: <20090211011933.GB28946@ZenIV.linux.org.uk>
References: <4991497B.4030200@cn.fujitsu.com>
	 <6599ad830902100215o185edd31k8731e033717dbb49@mail.gmail.com>
	 <20090210124527.GA28946@ZenIV.linux.org.uk>
	 <6599ad830902101601i294ffaa5xd01611c5121a5685@mail.gmail.com>
	 <20090211011933.GB28946@ZenIV.linux.org.uk>
Date: Tue, 10 Feb 2009 17:54:07 -0800
Message-ID: <6599ad830902101754w50a64b0ds126510360fdef28e@mail.gmail.com>
Subject: Re: [PATCH] cgroups: fix possible use after free
From: Paul Menage <menage@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 5:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> So you can't wrap sget() into a mutex that might be grabbed at some
> point of ->kill_sb() or it'll wait forever in that scenario.

Good point.

>
> So no exclusion is needed there at all.  If you don't want later remount
> of the first mount to affect these flags of second one you shouldn't share
> the superblock at all, obviously...

I have plans for some slightly more complex state in that structure -
I'll probably just add a spinlock around accesses to those fields so
that we can avoid exposing any inconsistent state.

Paul
