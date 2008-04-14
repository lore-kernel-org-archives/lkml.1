Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbYDNLxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbYDNLxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 07:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYDNLxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 07:53:31 -0400
Received: from www.tglx.de ([62.245.132.106]:39662 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbYDNLxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 07:53:30 -0400
Date: Mon, 14 Apr 2008 13:52:59 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: [PATCH 4/4 v2] [RFC] UIO: generic platform driver
Message-ID: <20080414115259.GB3199@local>
References: <20080411110358.GC19973@digi.com> <20080411111703.GD3185@local> <20080411112543.GA23221@digi.com> <20080412131646.GF9669@flint.arm.linux.org.uk> <20080414074858.GA22694@digi.com> <20080414093714.GD1540@flint.arm.linux.org.uk> <20080414095445.GA19413@digi.com> <20080414101701.GE1540@flint.arm.linux.org.uk> <20080414112021.GA19986@digi.com> <20080414113759.GG1540@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080414113759.GG1540@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 12:37:59PM +0100, Russell King - ARM Linux wrote:
> On Mon, Apr 14, 2008 at 01:20:21PM +0200, Uwe Kleine-König wrote:
> > [1] http://lkml.org/lkml/2008/4/11/81 or
> > http://thread.gmane.org/gmane.linux.kernel/665257
> 
> In one of the mails, it was said:
>   No. It's more important to see which variables are declared in the
>   function and which are declared elsewhere. If you have to search the
>   whole body of a function for possible declarations, this is BAD. And if
>   it's not clear where a variable is used, the function is too long or has
>   other style problems. Your function is short and clean, so where's the
>   problem? Please move the declaration to the top of the function.
> 
> I disagree with this statement.  It's far better to limit the scope of
> variables so that you know they only have local use, and eg, not used
> inside a loop and then outside with possible unintended effects.
> 
> If a variable is only used inside a loop, it should be declared _inside_
> that loop.
> 
> The statement goes on to talk about the function being short and clean -
> that's not an argument to apply any particular point of view on this
> subject, since you can argue that because it's short and clean you can
> see that the variable is only used within the loop.
> 
> So, please, keep the variable declaration inside the loop, and don't
> pollute the outer levels with unnecessary variable declarations.

OK, I'm finally convinced :-)
I knew this style from C++ where it makes sense, because a (class-)
variable declaration can implicitly call the constructor of that class
which you normally want to avoid if not needed. As this doesn't happen
in C, I found it unnecessary.
I agree now that there's also a readability argument. The limitation of
the scope is probably not that important as compilers will optimize that
anyway in a lot of cases.

Thanks,
Hans
