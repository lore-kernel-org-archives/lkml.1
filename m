Return-Path: <linux-kernel-owner+w=401wt.eu-S1761675AbYCDDZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761675AbYCDDZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 22:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbYCDDY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 22:24:56 -0500
Received: from ozlabs.org ([203.10.76.45]:53982 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYCDDYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 22:24:55 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v2] Whine about suspicious return values from module's ->init() hook
Date: Tue, 4 Mar 2008 14:24:02 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, adobriyan@sw.ru,
       linux-kernel@vger.kernel.org
References: <20080204154215.GA26618@localhost.sw.ru> <200802061755.27057.rusty@rustcorp.com.au> <20080210220906.GG1754@martell.zuzino.mipt.ru>
In-Reply-To: <20080210220906.GG1754@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041424.03092.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 February 2008 09:09:06 Alexey Dobriyan wrote:
> On Wed, Feb 06, 2008 at 05:55:26PM +1100, Rusty Russell wrote:
> > I think you misunderstand.  I proposed that we audit all the code before
> > such a change.  We shouldn't do *anything* until we can estimate the
> > impact this change will have.
>
> With such rate of changes, good luck doing that.

I'm not convinced that people are introducing bugs that fast :)

> > Our users deserve better than "I don't know if this will break anything
> > so I used WARN_ON".  They deserve "we have confidence that this change
> > won't break any existing code".
> >
> > Now, if an audit is impractical or unreliable, we are better off with a
> > WARN_ON.
>
> It's impractical as in it's extremely boring to read every modules init
> function and propagate return values in mind.

Sure, I'd start by writing some filters for all the easy cases.  It'd probably 
only take a day to do them all.

The thing is, every time I do an audit like this, I find all kinds of things 
to fix; it's not actually a useless exercise.

> > But it is still an admission of ignorance.
>
> I love BUG_ON and BUILD_BUG_ON very much but on such scale you can't
> just throw them in.
>
> Here goes version 2 with improved changelog. Let's put in -mm and see
> what happens, then put it in mainline and see what happens.

Sure, I've put it in my tree for the moment.

Thanks,
Rusty.
