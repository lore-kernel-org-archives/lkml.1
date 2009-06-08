Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbZFHQ33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbZFHQ33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbZFHQ3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:29:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45441 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbZFHQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:29:19 -0400
Date: Mon, 8 Jun 2009 17:29:13 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, hugh@veritas.com, tj@kernel.org,
       adobriyan@gmail.com, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, gregkh@suse.de, npiggin@suse.de,
       akpm@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 0/23] File descriptor hot-unplug support v2
Message-ID: <20090608162913.GL8633@ZenIV.linux.org.uk>
References: <m1skkf761y.fsf@fess.ebiederm.org> <m1oct739xu.fsf@fess.ebiederm.org> <20090606080334.GA15204@ZenIV.linux.org.uk> <E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MDbLz-0003wm-Db@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 11:41:19AM +0200, Miklos Szeredi wrote:
> On Sat, 6 Jun 2009, Al Viro wrote:
> > Frankly, I very much suspect that force-umount is another case like that;
> > we'll need a *lot* of interesting cooperation from fs for that to work and
> > to be useful.  I'd be delighted to be proven incorrect on that one, so
> > if you have anything serious in that direction, please share the details.
> 
> Umm, not sure why we'd need cooperation from the fs.  Simply wait for
> the operation to exit the filesystem or driver.  If it's a blocking
> operation, send a signal to interrupt it.

And making sure that operations *are* interruptible (and that we can cope
with $BIGNUM new failure exits correctly) does not qualify as cooperation?
