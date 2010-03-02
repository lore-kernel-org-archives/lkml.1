Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0CBIFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 03:05:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab0CBIFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 03:05:37 -0500
Date: Tue, 2 Mar 2010 10:05:27 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, avi@redhat.com, mtosatti@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
Message-ID: <20100302080527.GT16909@redhat.com>
References: <20100301091819.GD16909@redhat.com>
 <4B8BE7C1.40000@redhat.com>
 <20100301174724.GA12867@redhat.com>
 <4B8C09F5.9070506@redhat.com>
 <20100301190341.GD12867@redhat.com>
 <4B8C1320.6060602@redhat.com>
 <4B8C4032.7080703@zytor.com>
 <4B8C463B.7070900@zytor.com>
 <4B8C4F12.8050009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8C4F12.8050009@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 01:34:42PM -1000, Zachary Amsden wrote:
> On 03/01/2010 12:56 PM, H. Peter Anvin wrote:
> >On 03/01/2010 02:31 PM, H. Peter Anvin wrote:
> >>On 03/01/2010 11:18 AM, Zachary Amsden wrote:
> >>>It's going to be ugly to emulate segmentation, NX and write protect
> >>>support without hardware to do this checking for you, but it's just what
> >>>you have to do in this slow path - tedious, fully specified emulation.
> >>>
> >>>Just because it's tedious doesn't mean we need to use setjmp / longjmp.
> >>>Throw / catch might be effective, but it's still pretty bizarre to do
> >>>tricks like that in C.
> >>>
> >>Well, setjmp/longjmp really is not much more than exception handling in C.
> >>
> >For what it's worth, I think that setjmp/longjmp is not anywhere near as
> >dangerous as people want to make it out to be.  gcc will warn for
> >dangerous uses (and a lot of non-dangerous uses), but generally the
> >difficult problems can be dealt with by moving the setjmp-protected code
> >into a separate function.
> 
> I'd be curious to see if it would need to evolve it to preemptsetjmp
> / irqlongjmp or some other more complex forms in time.
> 
Just don't allow stupid usage of longjmp. Like everything else
it can be abused.

> But I'd rather implement a new language where acquisition of
> resources such as locks, dynamically allocated objects, and ref
> counts are predicated in the function typing and are heavily
> encouraged to possess defined inverses.  Then the closure of a
> particular layer of nesting already has enough information to
> provide release upon escape, and the compiler can easily take the
> burden of checking for a large class of lock and resource violation.
> 
> And it would have to be prettier than the current languages that do
> that, meaning operator overloading would be banned.  Although it
> would define rational numbers, super-extended precision arithmetic,
> imaginary numbers, quaternions and matrices as part of the spec, so
> there would be no need to use arithmetic overrides anyway, and then
> all the nonsensical operators could die, die, die, especially the
> function () and logical operator overrides.
> 
Will you language have a lot of parentheses?

--
			Gleb.
