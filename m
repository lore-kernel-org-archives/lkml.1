Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbXEBHEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbXEBHEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbXEBHEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:04:20 -0400
Received: from ozlabs.org ([203.10.76.45]:57433 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbXEBHET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:04:19 -0400
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
	 <1178084403.28659.222.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
	 <1178087393.28659.238.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Wed, 02 May 2007 17:04:04 +1000
Message-Id: <1178089444.28659.246.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 23:41 -0700, David Rientjes wrote:
> On Wed, 2 May 2007, Rusty Russell wrote:
> 
> > OTOH, your point about "__unneeded" is well taken.  "__needed" and
> > "__optional" perhaps?  But their feature is *exactly* that the don't
> > look like the gcc attributes, hence avoid their semantic screwage.
> > 
> 
> Hmm, __optional doesn't sound appropriate either.  Since this is going to 
> be defined to be __attribute__ ((unused)), it can apply to both functions 
> and variables.  It should be applied to a function if it truly is 
> unreferenced within the tree (and there are several examples of this 
> current HEAD) and we don't want to use __needed because it still emits the 
> function code even though it suppresses the warning.  So saying a function 
> that has no callers is "__optional" makes no sense since its code isn't 
> going to be emitted in gcc >=3.4.

Hi David,

	That sounds exactly right to me!  If the author says it's optional, it
might be discarded.  If they say it's needed, it won't be.  At least,
when I'm coding and gcc warns me something is unused, this is the
decision I have to make ("is this really needed or not?").

> What's your opinion of my __needed and __maybe_unused idea such as the 
> following?

You mean __used and __maybe_unused?  I still think there's a gap between
what the author wants to say ("No, you really have to keep this!" or
"OK, this might not be necessary") and the concept of "used" and
"unused".

Cheers,
Rusty.

