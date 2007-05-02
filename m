Return-Path: <linux-kernel-owner+w=401wt.eu-S2993273AbXEBOqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993273AbXEBOqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 10:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993276AbXEBOqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 10:46:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49954 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993273AbXEBOqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 10:46:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dean Nelson <dcn@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: "partical" kthread conversion
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<20070501084245.GA14364@infradead.org>
	<20070501015141.f09f6dde.akpm@linux-foundation.org>
	<20070502140115.GA23595@sgi.com>
Date: Wed, 02 May 2007 08:45:54 -0600
In-Reply-To: <20070502140115.GA23595@sgi.com> (Dean Nelson's message of "Wed,
	2 May 2007 09:01:15 -0500")
Message-ID: <m11whzxp0d.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dean Nelson <dcn@sgi.com> writes:

> On Tue, May 01, 2007 at 01:51:41AM -0700, Andrew Morton wrote:
>> > There's probably a few more patches falling into this category, these
>> > were just the first one the stick into my eye.
>> 
>> Yes, I think I'll probably drop all of them - I've completely lost track of
>> which ones are complete, which ones need more work, etc.

Andrew as far as dropping them.  If all you have is one of my dinky patches
that changes things to use kthread_run feel free, because of the general
necessity of calling kthread_stop I'm going to have to rework those anyway,
and I still have the originals.

If there is something more the we probably want to keep the patch because
someone has actually looked at it and done something useful.

I'm just now starting to work my way through them all again paying a little
closer attention, so I can do a thorough conversion.

>> I might send ia64-sn-xpc-convert-to-use-kthread-api.patch+fixes off to
>> Tony, as people put quite a bit of review and test effort into that one.
>
> Andrew, I would recommend holding off on sending these xpc patches to
> Tony as the kthread_run()s aren't paired with kthread_stop()s yet. I
> need to generate an additional patch after I've first sorted out how
> best to deal with kthread_stop()'ng XPC's pool of kthreads with Eric.

Ok.  Dean gve me a couple of a day or so.  I think I have just worked
through how to directly create kthreads without too much pain.  We are
still going to need kthreadd for spawning for a bit because I don't
expect all architectures to change over immediately, but I think
things can be done in a fairly simple low risk manner.

The changes to the kernel_thread replacement aren't going to be too
bad, pretty much just adding a couple of parameters.   It is
copy_thread where things get sticky.

If we can spawn threads fast enough we don't need a thread pool, I
would rather do that.

Eric
