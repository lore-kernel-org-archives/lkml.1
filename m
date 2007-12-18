Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbXLRXOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbXLRXOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXLRXOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:14:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35548 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbXLRXOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:14:07 -0500
Date: Tue, 18 Dec 2007 23:14:04 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Mark Lord <lkml@rtr.ca>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
Message-ID: <20071218231404.GG8181@ftp.linux.org.uk>
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218230016.GF8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 11:00:16PM +0000, Al Viro wrote:
> On Tue, Dec 18, 2007 at 05:46:21PM -0500, Mark Lord wrote:
> > Why does link(2) not support hard-linking across bind mount points
> > of the same underlying filesystem ?
> 
> Because it gives you a security boundary around a subtree.

PS: that had been discussed quite a few times, but to avoid searches:
consider e.g. mount --bind /tmp /tmp; now you've got a situation when
users can't create links to elsewhere no root fs, even though they
have /tmp writable to them.  Similar technics works for other isolation
needs - basically, you can confine rename/link to given subtree.  IOW,
it's a deliberate feature.  Note that you can bind a bunch of trees
into chroot and get predictable restrictions regardless of how the
stuff might get rearranged a year later in the main tree, etc.
