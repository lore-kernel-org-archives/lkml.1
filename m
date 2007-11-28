Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbXK1Sa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbXK1Sa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXK1Saq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:30:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54760 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXK1Sap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:30:45 -0500
Date: Wed, 28 Nov 2007 18:30:40 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Valdis.Kletnieks@vt.edu
Cc: Christoph Hellwig <hch@infradead.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071128183040.GW8181@ftp.linux.org.uk>
References: <20071128144156.GA14106@infradead.org> <416908.77038.qm@web36613.mail.mud.yahoo.com> <20071128164613.GA21815@infradead.org> <25290.1196273705@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25290.1196273705@turing-police.cc.vt.edu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 01:15:05PM -0500, Valdis.Kletnieks@vt.edu wrote:
> (Note that the concept has interesting implications in the other direction as
> well - rather than stopping you from reading a file that has malware, you could
> in theory write an anti-export package that would let you write onto external
> memory or outbound e-mail, but prevent the write if it was corporate-sensitive
> data, or whatever.

You _can_ _not_ do that.  If shared mapping gets dirtied, you have no way to
intercept that.  At all.  Especially since the page stays mapped while it is
written out, so the next modification can come when hardware had already
started outbound DMA and there's no way to abort it, no matter what your
external scanner would do.

Folks, really, that doesn't work.  At all.  You can intercept all system
calls you want and it will not be enough to prevent the "bad" contents
from hitting the disk.

And if we are talking about the situation when files are written to in
controlled way (i.e. we are not concerned with malware running on the box
in question and just want to stop it from passing through mailsewer, etc.),
then there's no damn need to play with LSM - just have e.g. coda with its
commit-on-close and run the scanner on commit.  End of story.  Mind you,
in such setups one would be much better off just having the mail server run
the tests explicitly in the userland, along with the rest of anti-spam, etc.
filters.
