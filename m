Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZG2QBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZG2QBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZG2QBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:01:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46390 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754376AbZG2QBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:01:04 -0400
Date: Wed, 29 Jul 2009 08:59:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pavel Machek <pavel@ucw.cz>
cc: Krzysztof Oledzki <olel@ans.pl>, Troy Moure <twmoure@szypr.net>,
       Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <20090729145702.GA1534@ucw.cz>
Message-ID: <alpine.LFD.2.01.0907290851200.3161@localhost.localdomain>
References: <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain> <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain>
 <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain> <alpine.LFD.2.00.0907212211040.4630@troy-laptop> <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain> <alpine.LFD.2.01.0907211811410.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907221546480.26357@bizon.gios.gov.pl> <alpine.LFD.2.01.0907220846350.19335@localhost.localdomain> <20090729145702.GA1534@ucw.cz>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 29 Jul 2009, Pavel Machek wrote:
> 
> So... we are going to just work around the gcc bug in the kernel?

Well, the gcc people hopefully will fix it in the 4.2.4 tree too.

Also, it's not exactly the first time we work around compiler bugs. We've 
done it before, I'm sure we'll do it again.

In this case, the work-around is trivial, and in many ways makes the code 
more "normal" (it's just a loop counter, might as well use an "int" for 
it), so there are no downsides to it. 

We could disallow gcc-4.2.4 entirely, of course, and have a big "this 
compiler is known to generate broken code" message and refuse to compile 
the kernel with it, but while that would be a "safer" approach, it would 
be rather user-unfriendly.

Compiler bugs happen. They're really really annoying, and nasty to track 
down. But they aren't the end of the world, and the pattern of this 
particular bug doesn't seem like it would likely trigger anywhere else.

For example, I suspect it really does need that loop induction variable to 
be 'unsigned char', and it really needs that limit to be exactly 128. It 
looks like a combination of loop optimization and broken range logic. I 
doubt it would hit in some random code that just happens to compare an 
unsigned char against 128 in general.

And using 'unsigned char' as a lop induction variable is _very_ rare. 
Which is probably why the gcc bug happened in the first place - no 
testing.

			Linus
