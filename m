Return-Path: <linux-kernel-owner+w=401wt.eu-S2992847AbXEBGaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992847AbXEBGaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992859AbXEBGaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:30:10 -0400
Received: from ozlabs.org ([203.10.76.45]:47353 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992847AbXEBGaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:30:07 -0400
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
	 <1178084403.28659.222.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 16:29:53 +1000
Message-Id: <1178087393.28659.238.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 23:06 -0700, David Rientjes wrote:
> On Wed, 2 May 2007, Rusty Russell wrote:
> 
> > Adding this macro doesn't give us anything that simply saying
> > "__attribute__((unused))" doesn't give.  But it does add a layer of
> > kernel-specific indirection.
> > 
> 
> That's obviously true since we're defining __attribute_unused__ to be 
> __attribute__((unused)).

Hi David,

	I'm horribly familiar with this issue, BTW, so we don't need so many
words 8)

> The patched version makes this:
> 
> 	int type __attribute_unused__ = 0;
>
> which definitely tells you that you're using a compiler attribute that 
> will be attached to that automatic.  In your case:
> 
> 	int type __unneeded = 0;
> 
> doesn't say anything in this case.  It doesn't resemble any attribute that 
> a programmer might be familiar with and begs the question of why we've 
> declared it if it's truly "unneeded"?

Your version makes one wonder why they didn't use
"__attribute__((unused))".  Obviously the __attribute_unused__ macro
exists for a reason, so they wonder what's the difference between that
and the attribute?  The answer: nothing.

OTOH, your point about "__unneeded" is well taken.  "__needed" and
"__optional" perhaps?  But their feature is *exactly* that the don't
look like the gcc attributes, hence avoid their semantic screwage.

> By the way, there are tons of these instances where __attribute__((used)) 
> needs to be added in driver code to suppress unreferenced warnings.

Sure; historically we refactor around it.  But warnings are now so
commonplace few people care 8(

Cheers,
Rusty.


