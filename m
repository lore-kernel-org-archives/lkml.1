Return-Path: <linux-kernel-owner+w=401wt.eu-S1753091AbZEDGNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbZEDGNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 02:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZEDGN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 02:13:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45463 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZEDGN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 02:13:28 -0400
Date: Mon, 4 May 2009 07:13:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       David <david@unsolicited.net>
Subject: Re: [PATCH] reiserfs: Expand i_mutex to enclose lookup_one_len
Message-ID: <20090504061327.GG8633@ZenIV.linux.org.uk>
References: <49FB1F20.8040400@suse.com> <20090503085236.GT8633@ZenIV.linux.org.uk> <20090503091507.GU8633@ZenIV.linux.org.uk> <49FE7448.2040302@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FE7448.2040302@suse.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 04, 2009 at 12:51:20AM -0400, Jeff Mahoney wrote:

> Huh. I didn't see that still in there. That's an artifact of an earlier
> version of the code where I kept a reference to /.reiserfs_priv/xattrs.
> Then I decided that .reiserfs_priv was all I needed to cache (to avoid
> recursive i_mutex locking on the fs root) and dropped the caching of
> xattrs. Looks like it didn't get totally cleared out.

It's not that simple ;-/  You check it in journalling code, AFAICS in order
to decide how much will that sucker take (due to extra mkdir?) and something
will need to be done with that check.

Anyway, I'm going to push all that stuff to #for-next, so that -next would
pick it.  I have *not* touched the xattr_root logics, so if you could do
that on top of your patch + my incremental...
