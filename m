Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbZJHU0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbZJHU0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759606AbZJHU0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:26:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759550AbZJHU0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:26:02 -0400
Date: Thu, 8 Oct 2009 13:25:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Bottomley <James.Bottomley@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
In-Reply-To: <1255032244.4187.267.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.01.0910081309310.3432@localhost.localdomain>
References: <1254844007.4383.85.camel@mulgrave.site>  <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>  <1254862442.4383.183.camel@mulgrave.site>  <1255012399.4187.24.camel@mulgrave.site>  <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
  <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain>  <1255031298.4187.260.camel@mulgrave.site>  <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain> <1255032244.4187.267.camel@mulgrave.site>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Oct 2009, James Bottomley wrote:
> 
> OK, you're saying the merge window exemption should only apply to
> drivers which meet our coding standards.

Well, to me, it's not even "coding standards". It's more about "letting 
things slide so that users get their hands on things earlier, since it 
can't really regress". Coding standards are obviously a part of that, but 
I think the coding standard question should come into this mainly in the 
sense of "should it go through staging or not" kind of sense, not in the 
timing sense.

The reason I object to this driver at this point is that I really think 
there's a _huge_ difference between some random average driver, and a 50 
kloc monster driver that basically seems to implement its own protocol.

Most random new drivers tend to be a few hundred lines of code, in some 
cases a few thousand. They don't generally bring in their own subsystem 
code, they often just hook into existing things like the libata layer or 
the network driver infrastructure etc.

So most drivers are in a totally different class than the one I'm 
objecting to in the SCSI tree.

And I also really do think there is a huge difference between some 
specialized high-end SCSI driver that is only relevant to enterprise 
people and some more average driver that is expected to perhaps exist in 
lots of consumer devices. How many people does it affect, and what's their 
ability to handle it?

Another way of putting that "consumer" vs "enterprise" thing: how big is 
the _upside_ of merging the driver outside fo the merge window? Again, I 
simply think pure number of potential users matters for the "should we let 
it slide" question.

			Linus
