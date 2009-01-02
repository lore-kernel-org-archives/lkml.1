Return-Path: <linux-kernel-owner+w=401wt.eu-S1759571AbZABS2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571AbZABS2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758630AbZABS2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:28:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46610 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757997AbZABS2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:28:03 -0500
Date: Fri, 2 Jan 2009 18:27:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, bfields@fieldses.org,
       xfs-masters@oss.sgi.com, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [xfs-masters] RFC: Fix f_flags races without the BKL
Message-ID: <20090102182757.GF28946@ZenIV.linux.org.uk>
References: <20081229041352.6bbdf57c@tpl> <20081229125050.GA22909@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229125050.GA22909@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2008 at 01:50:50PM +0100, Christoph Hellwig wrote:
> On Mon, Dec 29, 2008 at 04:13:52AM -0700, Jonathan Corbet wrote:
> > Accesses to the f_flags field have always involved a read-modify-write
> > operation, and have always been racy in the absence of the BKL.  The recent
> > BKL-removal work made this problem worse, but it has been there for a very
> > long time.  The race is quite small, and, arguably, has never affected
> > anybody, but it's still worth fixing.
> > 
> > After pondering for a while, I couldn't come up with anything better than a
> > global file->f_flags mutex.  There's no point in bloating struct file with
> > a mutex just for this purpose; it's hard to imagine that there will be any
> > real contention for this lock.
> 
> What speaks against having on in fs_struct so that it's at least not
> globally serialized?

WTF?  References to struct file can be shared by tasks with different
associated fs_struct; how the devil can that ever work?
