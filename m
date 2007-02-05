Return-Path: <linux-kernel-owner+w=401wt.eu-S933369AbXBES6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933369AbXBES6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:58:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933366AbXBES6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:58:38 -0500
Received: from pat.uio.no ([129.240.10.15]:55341 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933359AbXBES6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:58:36 -0500
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       linux-security-module@vger.kernel.org, agruen@suse.de,
       viro@zeniv.linux.org.uk
In-Reply-To: <20070205184410.GA20672@infradead.org>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
	 <20070205184410.GA20672@infradead.org>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 10:58:26 -0800
Message-Id: <1170701906.5934.41.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 439493BB11E9DE0890B3D6211BFBDD9AE15603EC
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 815 total 269908 max/h 2716 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 18:44 +0000, Christoph Hellwig wrote:
> Just FYI:  Al was very opposed to the idea of passing the vfsmount to
> the vfs_ helpers, so you should discuss this with him.
> 
> Looking at the actual patches I see you're lazy in a lot of places.
> Please make sure that when you introduce a vfsmount argument somewhere
> that it is _always_ passed and not just when it's conveniant.  Yes, that's
> more work, but then again if you're not consistant anyone half-serious
> will laught at a security model using this infrasturcture.

nfsd in particular tends to be a bit lazy about passing around vfsmount
info. Forcing it to do so should not be hard since the vfsmount is
already cached in the "struct export" (which can be found using the
filehandle). It will take a bit of re-engineering in order to pass that
information around inside the nfsd code, though.

Note also that it might be nice to enforce the vfsmount argument by
replacing the existing dentry parameters with a struct path instead of
adding an extra reference to the vfsmount to existing functions.

Cheers,
  Trond

