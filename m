Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbYL2MwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbYL2MwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 07:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYL2Mvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 07:51:52 -0500
Received: from verein.lst.de ([213.95.11.210]:44632 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbYL2Mvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 07:51:51 -0500
Date: Mon, 29 Dec 2008 13:50:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       bfields@fieldses.org, xfs-masters@oss.sgi.com,
       Andi Kleen <andi@firstfloor.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [xfs-masters] RFC: Fix f_flags races without the BKL
Message-ID: <20081229125050.GA22909@lst.de>
References: <20081229041352.6bbdf57c@tpl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229041352.6bbdf57c@tpl>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
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

What speaks against having on in fs_struct so that it's at least not
globally serialized?

