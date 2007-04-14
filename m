Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbXDNRe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbXDNRe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 13:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXDNRe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 13:34:26 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58267 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbXDNReZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 13:34:25 -0400
Date: Sat, 14 Apr 2007 10:34:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Junio C Hamano <junkio@cox.net>
cc: Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       git@vger.kernel.org
Subject: Re: GIT and the current -stable
In-Reply-To: <7vfy73bhik.fsf@assigned-by-dhcp.cox.net>
Message-ID: <Pine.LNX.4.64.0704141028460.5473@woody.linux-foundation.org>
References: <46206842.80203@gmail.com> <7vfy73bhik.fsf@assigned-by-dhcp.cox.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Apr 2007, Junio C Hamano wrote:
> 
> I think adding these lines to .git/config would do the trick,
> after you have done the "checkout -b v2.6.20 v2.6.20" step:
> 
> [branch "v2.6.20"]
> 	remote = stable
> 	merge = refs/heads/master

Please don't do this. Using the same name for a branch as for a tag is 
madness. Call it "v2.6.20-stable" or anything else, but don't re-use the 
same naming as for tags.

Sure, git will have some random well-defined order of parsing which one 
"v2.6.20" actually means in any particular context (usually the tag-name 
will take precedence, except for contexts where the branchname is 
required!), and yeah, you can always make things unambiguous by specifying 
the full name (ie say "[refs/]tags/v2.6.20" when you want to make sure 
it's unambiguously the tag, not the branch) but it's still guaranteed to 
cause confusion at *some* level, if only for the user.

So just don't do it. 

		Linus
