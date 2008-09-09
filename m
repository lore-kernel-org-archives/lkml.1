Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbYIITo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbYIITo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 15:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753782AbYIITov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 15:44:51 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56342 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbYIITou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 15:44:50 -0400
Date: Tue, 9 Sep 2008 22:43:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Keith A. Prickett" <keithp@marvell.com>, linux-kernel@vger.kernel.org
Subject: Re: Building Kernel with -O0
Message-ID: <20080909194305.GG30160@cs181140183.pp.htv.fi>
References: <1220550653.15123.6.camel@CV-LAB2> <20080909160452.GB30160@cs181140183.pp.htv.fi> <1220980240.17292.15.camel@CV-LAB2> <87vdx5ruk5.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87vdx5ruk5.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 09:24:58PM +0200, Andi Kleen wrote:
> "Keith A. Prickett" <keithp@marvell.com> writes:
> >
> > All of this could, potentially be changed by a configuration parameter
> > and added into the kernel release.  Does someone have a primer on why
> > this kind of behavior is not desired or "possible"?
> 
> Traditionally it was not allowed because -O0 didn't inline and
> the kernel relied on inlining in some cases. But with always_inline
> that is obsolete -- all functions that rely on inlining should be 
> marked __always_inline.
> 
> I think a few more cases crept in where it was common to write
> build time asserts as
> 
>       if (some condition the compiler evaluates at runtime)
                                                     ^^^^^^^
buildtime

>          __error_condition_xyz_is_false(); 
>  
> and this obviously relies on the optimizer to build. But these
> are all slowly moving over the BUILD_BUG_ON() which also doesn't
> rely on the optimizer, so it's also obsolete.
>...

The reason why it works for Keith at all seems to be that even with -O0 
gcc already does this kind of optimizations.

Check e.g. the assembler generated for the following
(userspace) program with -O0:

<--  snip  -->

int foobar;

int main()
{ 
	if (1) return 0;

	foobar = 12345;

	return 42;
}

<--  snip  -->

> Hope this helps,
> 
> -Andi

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

