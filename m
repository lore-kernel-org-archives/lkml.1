Return-Path: <linux-kernel-owner+w=401wt.eu-S2993383AbXEBPhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993383AbXEBPhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993381AbXEBPhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:37:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37970 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2993379AbXEBPh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:37:29 -0400
Date: Wed, 2 May 2007 10:37:27 -0500
From: Dean Nelson <dcn@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: akpm@linux-foundation.org, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: "partical" kthread conversion
Message-ID: <20070502153727.GA31794@sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <20070501084245.GA14364@infradead.org> <20070501015141.f09f6dde.akpm@linux-foundation.org> <20070502140115.GA23595@sgi.com> <m11whzxp0d.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11whzxp0d.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 08:45:54AM -0600, Eric W. Biederman wrote:
> Dean Nelson <dcn@sgi.com> writes:
> 
> > On Tue, May 01, 2007 at 01:51:41AM -0700, Andrew Morton wrote:
> >> I might send ia64-sn-xpc-convert-to-use-kthread-api.patch+fixes off to
> >> Tony, as people put quite a bit of review and test effort into that one.
> >
> > Andrew, I would recommend holding off on sending these xpc patches to
> > Tony as the kthread_run()s aren't paired with kthread_stop()s yet. I
> > need to generate an additional patch after I've first sorted out how
> > best to deal with kthread_stop()'ng XPC's pool of kthreads with Eric.
> 
> Ok.  Dean gve me a couple of a day or so.  I think I have just worked
> through how to directly create kthreads without too much pain.  We are
> still going to need kthreadd for spawning for a bit because I don't
> expect all architectures to change over immediately, but I think
> things can be done in a fairly simple low risk manner.
> 
> The changes to the kernel_thread replacement aren't going to be too
> bad, pretty much just adding a couple of parameters.   It is
> copy_thread where things get sticky.
> 
> If we can spawn threads fast enough we don't need a thread pool, I
> would rather do that.

I'd typed up some questions for you about the new patch I need to create
which I'd just sent to you, so I won't repeat them here.

Before proceeding to far with your above changes, you might wait to see
the proposal that Robin Holt is putting together for a kthread pool.
I'm not sure how spawning a thread (which involves allocation of the
task_struct amongst other things, plus scheduling) can beat a wake_up()
of an already existing thread for cost time-wise.

Dean

