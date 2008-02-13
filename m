Return-Path: <linux-kernel-owner+w=401wt.eu-S1763566AbYBMBBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763566AbYBMBBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYBMBAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:00:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbYBMBAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:00:51 -0500
Date: Tue, 12 Feb 2008 16:59:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: "J. Bruce Fields" <bfields@fieldses.org>,
       David Miller <davem@davemloft.net>, jeff@garzik.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linville@tuxdriver.com
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
In-Reply-To: <20080213004841.GM27894@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.00.0802121654300.2920@woody.linux-foundation.org>
References: <20080212055312.GA5631@kroah.com> <20080211.220726.157328337.davem@davemloft.net> <47B1C9F4.30402@garzik.org> <20080212.155107.251983955.davem@davemloft.net> <20080212235401.GL27894@ZenIV.linux.org.uk> <20080213001650.GY18625@fieldses.org>
 <20080213004841.GM27894@ZenIV.linux.org.uk>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Feb 2008, Al Viro wrote:

> On Tue, Feb 12, 2008 at 07:16:50PM -0500, J. Bruce Fields wrote:
> > > Ahem...  Use of git-cherry-pick preserves commit information just fine.
> > 
> > Not by default, at least (note they said "commiters", not "authors"):
> 
> That's why you give it -r.

Hmm. "-r" is a no-op to git-cherry-pick.

And even if you thought it should preserve committer information, it 
really _really_ shouldn't. You're creating a new commit, you're the new 
committer. The old committer is meaningless. It doesn't matter at all if 
you try to keep the old committer information (which you can do by faking 
GIT_COMMITER_NAME¦EMAIL): you're simply just _lying_ at that point. The 
original committer has a different commit in his tree, and if you try to 
claim that your cherry-picked commit is his, you're only doing everybody a 
disservice.

If you meant using "-x", then yes, that retains the actual pointer to the 
original commit, but it's not the default, because it shouldn't be used 
unless you plan to carry both around on purpose (ie it's mainly useful for 
"maintain a stable branch that has commits cherry-picked from mainline" 
kinds of things).

			Linus
