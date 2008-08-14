Return-Path: <linux-kernel-owner+w=401wt.eu-S1758779AbYHNVVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779AbYHNVVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 17:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYHNVVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 17:21:25 -0400
Received: from mail.fieldses.org ([66.93.2.214]:55019 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbYHNVVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 17:21:24 -0400
Date: Thu, 14 Aug 2008 17:21:09 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Eric Paris <eparis@redhat.com>,
       tvrtko.ursulin@sophos.com, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       malware-list-bounces@dmesg.printk.net, peterz@infradead.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080814212109.GM23859@fieldses.org>
References: <20080813192922.GI8232@mit.edu> <20080814093103.6CD102FE8B4@pmx1.sophos.com> <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain> <20080814155028.GB8256@mit.edu> <1218734985.9375.5.camel@paris.rdu.redhat.com> <20080814191726.GG22488@mit.edu> <20080814193408.GA10236@infradead.org> <20080814194111.GH22488@mit.edu> <20080814202039.GA4509@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814202039.GA4509@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 04:20:39PM -0400, Christoph Hellwig wrote:
> On Thu, Aug 14, 2008 at 03:41:11PM -0400, Theodore Tso wrote:
> > We do need a standardized way of enabling it (since it does cost you
> > something in performance, so not everyone will want it on), and a
> > standardized way of reading i_version out to userspace.  Maybe a mount
> > option is the right way to do it, maybe not.
> > 
> > We may want to take this to the linux-fs list and try to get
> > agreements on these points; the main reason why it's not enabled by
> > default in ext4 is because the NFSv4 advanced caching code is in
> > common use (is it even in mainline)?
> 
> I have not yet seen code actually using it at all, neither in mainline
> nor on one of the many nfs development lists.

Oops, I'd love to, and it should be very easy.  How do I find out if
i_version is supported on a given superblock?

There's nothing particularly "advanced" about this, by the way--this is
a very minor variation on the caching model that nfs has always had, and
our nfsv4 server is currently pretty broken without it.

Actually, it's pretty broken even on nfsv2/v3 for filesystems with poor
time resolution.

--b.
