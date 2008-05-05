Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYEEMCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYEEMCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYEEMCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:02:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57441 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYEEMCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:02:39 -0400
Date: Mon, 5 May 2008 13:02:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Lothar Wa?mann <LW@KARO-electronics.de>
Cc: Willy Tarreau <w@1wt.eu>, NeilBrown <neilb@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: linux-2.6.25: 'mkdir -p' does not work with rootdir as mount
	point inside a read only filesystem
Message-ID: <20080505120234.GL5882@ZenIV.linux.org.uk>
References: <18456.34604.472989.35082@ipc1.ka-ro> <20080501215231.297e0d9d.akpm@linux-foundation.org> <53722.192.168.1.70.1209711343.squirrel@neil.brown.name> <20080503063231.GA688@1wt.eu> <18462.43245.728465.911831@ipc1.ka-ro> <20080505070214.GA14635@1wt.eu> <18462.45648.60033.233887@ipc1.ka-ro> <20080505072824.GE14635@1wt.eu> <18462.47505.453068.931094@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18462.47505.453068.931094@ipc1.ka-ro>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 09:38:57AM +0200, Lothar Wa?mann wrote:
> Hi,
> 
> Willy Tarreau writes:
> > > Interestingly your strace output showed a return value of EEXIST where
> > > mine had EROFS.
> > 
> > Oh you're right! I did not notice. There's something odd here.
> > And I can reproduce it right now (2.6.25.1). I really have
> > EEXIST.
> > 
> As I noted in my first message I have this problem with the kernel
> from git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
> which is currently 2.6.26-rc1 and still exhibits this behaviour.
> 
> So, this problem obviously does not exist in the 2.6.25 release kernel
> but would probably hit mainline in the 2.6.26 release.

Aye.  That's ro-bind fallout we'd not noticed; will fix...

And a fine example of the reasons why
	* relying on which particular errno value you get when several
are applicable is a Bad Idea(tm) and
	* changing the choice of the errno value in such situation might
be legal, but is to be done with care; sometimes it really has impact...
