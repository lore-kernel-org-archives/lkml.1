Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbYK0OLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbYK0OLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYK0OLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:11:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbYK0OLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:11:03 -0500
Date: Thu, 27 Nov 2008 15:10:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?B?VPZy9ms=?= Edwin <edwintorok@gmail.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, srostedt@redhat.com,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/2] tracing: identify which executable object the
	userspace address belongs to
Message-ID: <20081127141054.GB25657@elte.hu>
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <1227353328-16104-3-git-send-email-edwintorok@gmail.com> <y0my6z798de.fsf@ton.toronto.redhat.com> <1227782505.4454.1393.camel@twins> <20081127124851.GC23480@redhat.com> <492E9AB2.9030202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <492E9AB2.9030202@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Török Edwin <edwintorok@gmail.com> wrote:

> On 2008-11-27 14:48, Frank Ch. Eigler wrote:
> > Hi -
> >
> > On Thu, Nov 27, 2008 at 11:41:45AM +0100, Peter Zijlstra wrote:
> >   
> >>>> Impact: modify+improve the userstacktrace tracing visualization feature
> >>>> [...]
> >>>> You'll see stack entries like:
> >>>>    /lib/libpthread-2.7.so[+0xd370]
> >>>> [...]
> >>>>         
> >>> Can you suggest an actual distribution & architecture where this
> >>> facility may be tested/used?  It appears to require frame-pointer
> >>> stuff that AFAIK is not generally turned on for user-space.
> >>>       
> >> gentoo, just rebuild world with frame pointers ;-)
> >>     
> >
> > Well, that only goes so far.  If this feature turns out unable to work
> > without distributors recompiling all their stuff on, for example, x86-64,
> > then expectations need to be reset.
> 
> My assumption is that this feature will be used to trace individual 
> applications, and not the system as a whole. Then you only need libc 
> to be recompiled with frame pointers on, and your own 
> application/your own application's libraries.
> 
> That is what I want to use it for, and there isn't another solution 
> that allows me to do this. Sure I can trace userspace alone using 
> ptrace (which has its own overhead), and the kernel alone by using 
> ftrace, but I can't combine those traces in a meaningful manner. 
> If/when the kernel will support dwarf unwinding, it will only need 
> to provide an alternate implementation for save_stack_trace_user.

Yes.

> Even without frame pointers you can at least get the return address 
> to userspace, which may be inside your application for page faults.
> 
> If I need to do system-wide tracing, I can use my 32-bit chroot [*], 
> or boot my laptop which is 32-bit.
> 
> I don't think that this feature should get rejected just because it 
> is not easily usable from x86_64.
> 
> [*] I haven't tested yet if tracing 32-bit applications from a 
> 64-bit kernel works. It probably won't, and I'll need to use a 
> different struct stack_frame with 32-bit addresses.
> 
> Another approach I've though of would be to deliver a signal to 
> userspace on demand, and have the signal handler do the backtrace, 
> but that would unnecesary overhead.

Correct, that would be stupid.

Your patches are nice. Right now they are in tracing/core and 
linux-next already.

	Ingo
