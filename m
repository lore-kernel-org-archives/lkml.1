Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYIIUBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYIIUBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYIIUBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:01:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56948 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbYIIUBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:01:36 -0400
Date: Tue, 9 Sep 2008 22:05:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "Keith A. Prickett" <keithp@marvell.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Building Kernel with -O0
Message-ID: <20080909200517.GE7714@one.firstfloor.org>
References: <1220550653.15123.6.camel@CV-LAB2> <20080909160452.GB30160@cs181140183.pp.htv.fi> <1220980240.17292.15.camel@CV-LAB2> <87vdx5ruk5.fsf@basil.nowhere.org> <20080909194305.GG30160@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909194305.GG30160@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think a few more cases crept in where it was common to write
> > build time asserts as
> > 
> >       if (some condition the compiler evaluates at runtime)
>                                                      ^^^^^^^
> buildtime

Thank for the correction.

> 
> >          __error_condition_xyz_is_false(); 
> >  
> > and this obviously relies on the optimizer to build. But these
> > are all slowly moving over the BUILD_BUG_ON() which also doesn't
> > rely on the optimizer, so it's also obsolete.
> >...
> 
> The reason why it works for Keith at all seems to be that even with -O0 
> gcc already does this kind of optimizations.

What I mean is global optimization over the whole function, like
constant propagation. That is required for some of the more complex
macros like the *_user() ones.

Some expression evaluation is required by the C standard (e.g.
otherwise you couldn't generally declare global arrays with expressions)
While that's technically not required in the body of the function
outside declarations the compiler does it normally. But only inside
a statement. 

-Andi
