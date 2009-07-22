Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbZGVBKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbZGVBKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 21:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZGVBKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 21:10:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406AbZGVBKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 21:10:04 -0400
Date: Tue, 21 Jul 2009 18:07:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Troy Moure <twmoure@szypr.net>
cc: Krzysztof Oledzki <olel@ans.pl>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org,
       lwn@lwn.net, Ian Lance Taylor <iant@google.com>
Subject: Re: Linux 2.6.27.27
In-Reply-To: <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907211759180.19335@localhost.localdomain>
References: <20090720040655.GA11940@kroah.com> <4A645A45.9060509@ans.pl> <20090720151008.GC10015@suse.de> <alpine.LFD.2.01.0907200848530.13838@localhost.localdomain> <alpine.LNX.1.10.0907202341580.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907201504470.19335@localhost.localdomain>
 <alpine.LNX.1.10.0907210831210.29729@bizon.gios.gov.pl> <alpine.LNX.1.10.0907211154480.29729@bizon.gios.gov.pl> <alpine.LFD.2.01.0907210906400.19335@localhost.localdomain> <alpine.LFD.2.01.0907211133010.19335@localhost.localdomain>
 <alpine.LFD.2.00.0907212211040.4630@troy-laptop> <alpine.LFD.2.01.0907211726140.19335@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 21 Jul 2009, Linus Torvalds wrote:
> 
> Just out of curiosity, how did you find it? Now that I know where to look, 
> it's very obvious in the assembler diffs, but I didn't notice it until you 
> pointed it out just because there is so _much_ of the diffs...

Ahh. I think I see how you found it. Looking at the diffs, there's only a 
few places where the number of instructions changed by a big fraction. And 
there's only _one_ place that has a factor-of-three difference (26 lines 
in the correct cases, and 7 lines in the wrong one). Clever.

There's also a case in do_page_fault() where -fno-strict-overflow 
generates a _lot_ more instructions than the other cases (but not by a 
factor of three - but it expands 63 instructions to 100). I'm not seeing 
quite _why_ it does that, but it does various stupid things like multiply 
by 0x38 etc. But it doesn't look buggy, it just looks stupid.

Or did you just brute-force it and spend a lot of time eyeballing things?

			Linus
