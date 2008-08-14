Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbYHNXfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbYHNXfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYHNXe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:34:56 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:55578 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875AbYHNXez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:34:55 -0400
Date: Thu, 14 Aug 2008 19:34:30 -0400
From: Theodore Tso <tytso@mit.edu>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>,
       tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080814233430.GC13048@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Christoph Hellwig <hch@infradead.org>,
	Eric Paris <eparis@redhat.com>, tvrtko.ursulin@sophos.com,
	alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
	Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
	malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
	viro@ZenIV.linux.org.uk
References: <20080814093103.6CD102FE8B4@pmx1.sophos.com> <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain> <20080814155028.GB8256@mit.edu> <1218734985.9375.5.camel@paris.rdu.redhat.com> <20080814191726.GG22488@mit.edu> <20080814193408.GA10236@infradead.org> <20080814194111.GH22488@mit.edu> <20080814202039.GA4509@infradead.org> <20080814212109.GM23859@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814212109.GM23859@fieldses.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 05:21:09PM -0400, J. Bruce Fields wrote:
> > I have not yet seen code actually using it at all, neither in mainline
> > nor on one of the many nfs development lists.
> 
> Oops, I'd love to, and it should be very easy.  How do I find out if
> i_version is supported on a given superblock?

We don't have a way of exporting this fact at the moment.  I assume
the best way would be to add a flag in struct super.

> There's nothing particularly "advanced" about this, by the way--this is
> a very minor variation on the caching model that nfs has always had, and
> our nfsv4 server is currently pretty broken without it.

Well, if you're willing to try it out, as I've mentioned on my
blog[1][2], ext4 is working pretty well on my laptop --- I'm running
it as my primary filesystem.  There are a few problems with ext3
filesystems converted to use ext4, as opposed to starting afresh via
"mke2fs -t ext4dev /dev/hdXX" that we've just found in the past week
(and fixed within a day or two, although they haven't been pushed to
Linus yet), but overall, it's been pretty stable.

So this would be a good time for someone who is familiar wiht NFSv4 to
try it out and let us know if the i_version support is as you would
like in ext4 --- we're in the bugfixing/stablization phase right now,
so this would be an ideal time to get that feedback.  For more
information, on how to get started, please see:

http://ext4.wiki.kernel.org/index.php/Ext4_Howto

for instructions, and mount the filesystem with the "-o i_version"
mount option.

> Actually, it's pretty broken even on nfsv2/v3 for filesystems with poor
> time resolution.

And that's fixed in ext4 as well....

						- Ted

[1] http://thunk.org/tytso/blog/2008/06/30/ext4-is-now-the-primary-filesystem-on-my-laptop/
[2] http://thunk.org/tytso/blog/2008/08/08/fast-ext4-fsck-times/

