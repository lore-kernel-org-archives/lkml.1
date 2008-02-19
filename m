Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbYBSKpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbYBSKpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYBSKpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:45:33 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:46603 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbYBSKpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:45:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=PhtFXf0v3YEx3Y2AJRfmRi1MnBpaV+7gsV9iZqUVLD9L21sJHpJo5EV4jZ/2XMY1hADJGZAQMlAaWLuAtLJzv3H0HxOeY79+NWSuNdT8hMBzqEXpC6pqJeaUtVoQzPIARkAeNKVV+uFvzDbwgvppmyGBsv6/N6lY1/1WgoT8jvY=
Message-ID: <84144f020802190245p7c2a52f2r72f273d37cb001f9@mail.gmail.com>
Date: Tue, 19 Feb 2008 12:45:29 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Linux 2.6.25-rc2
Cc: "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080219102700.GC14092@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
	 <20080219061107.GA23229@elte.hu>
	 <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
	 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
	 <20080219102700.GC14092@elte.hu>
X-Google-Sender-Auth: e8a840cc054ba253
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > Mathieu, Christoph is on vacation and I'm not at all that familiar
> > with this cmpxchg_local() optimization, so if you could take a peek at
> > this bug report to see if you can spot something obviously wrong with
> > it, I would much appreciate that.

On Feb 19, 2008 12:27 PM, Ingo Molnar <mingo@elte.hu> wrote:
> hm, it's bad for at least one other reason as well (which is probably
> unrelated to this crash):
>
>  /*
>   * Currently fastpath is not supported if preemption is enabled.
>   */
>  #if defined(CONFIG_FAST_CMPXCHG_LOCAL) && !defined(CONFIG_PREEMPT)
>  #define SLUB_FASTPATH
>  #endif
>
> such !PREEMPT exceptions tend to show "i didnt want to think too hard
> about the preemptible case so just turn it off" thinking.
>
> Also, why isnt this "SLUB_FASTPATH" flag done in the Kconfig space?

Hmm, no idea. I think might have been some mix-up with merging the
patch. The one I saw was:

http://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/broken-out/slub-optional-fast-path-using-cmpxchg_local.patch

But I don't remember giving out a Reviewed-by for it (and my mailbox
confirms that). Furthermore, somehow it turned into this when merged:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=1f84260c8ce3b1ce26d4c1d6dedc2f33a3a29c0c

In any case, if Torsten/someone can verify that reverting
1f84260c8ce3b1ce26d4c1d6dedc2f33a3a29c0c ("SLUB: Alternate fast paths
using cmpxchg_local") fixes these problems, I think we should just do
it and let Christoph sort it out when he gets back.

                               Pekka
