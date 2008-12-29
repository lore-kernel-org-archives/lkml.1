Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYL2Lzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYL2Lzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYL2Lzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:55:37 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36378 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbYL2Lzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:55:36 -0500
Date: Mon, 29 Dec 2008 12:57:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, bfields@fieldses.org,
       xfs-masters@oss.sgi.com
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20081229115706.GA955@uranus.ravnborg.org>
References: <20081229041352.6bbdf57c@tpl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229041352.6bbdf57c@tpl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 04:13:52AM -0700, Jonathan Corbet wrote:
> Accesses to the f_flags field have always involved a read-modify-write
> operation, and have always been racy in the absence of the BKL.  The recent
> BKL-removal work made this problem worse, but it has been there for a very
> long time.  The race is quite small, and, arguably, has never affected
> anybody, but it's still worth fixing.
> 
> After pondering for a while, I couldn't come up with anything better than a
> global file->f_flags mutex.  There's no point in bloating struct file with
> a mutex just for this purpose; it's hard to imagine that there will be any
> real contention for this lock.
Rather than open coded mutex how about adding a few helpers to
set and clear the flags and hide locking there?

Not that your patch looks invasive..

	Sam
