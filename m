Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYLDWVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYLDWVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 17:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYLDWU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 17:20:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbYLDWU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 17:20:57 -0500
Date: Thu, 4 Dec 2008 14:20:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812042309.11540.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812041415020.3543@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812030735230.3256@nehalem.linux-foundation.org> <200812041229.45443.elendil@planet.nl> <200812042309.11540.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 4 Dec 2008, Rafael J. Wysocki wrote:
> 
> However, this one appears to work reliably for me (on top of vanilla current
> mainline):

Not very interesting. It just does the same thing your previous patches 
have done - ignores the cardbus slot for sizing. It just does it 
differently and more explicitly.

Your original patch did it by simply giving the resources invalid 
alignments (in a very non-obvious way). This one does it by being explicit 
and saying "we won't care about cardbus resources behind transparent 
bridges". But it's still a very hacky thing, and thus not really 
interesting at all as a patch.

IOW, it's not a patch that makes sense - it's just a patch that ON YOUR 
PARTICULAR MACHINE causes us to get the layout you want in order to hide 
the bug. And it doesn't really even do anything new - it's just doing the 
same thing in an old way.

But it's interesting that the "don't size _anything_ behind a transparent 
bridge" apparently made no difference for you.

Can you send "lspci -vv" and "dmesg" output for that kernel? Even if it 
failed the suspend/resume, it's interesting, because I would actually have 
expected that one to have the same layout as the successful ones.

			Linus
