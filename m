Return-Path: <linux-kernel-owner+w=401wt.eu-S1757656AbZABSmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656AbZABSmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 13:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757657AbZABSme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 13:42:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39794 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZABSme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 13:42:34 -0500
Date: Fri, 2 Jan 2009 18:42:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Oleg Nesterov <oleg@redhat.com>,
       bfields@fieldses.org, xfs-masters@oss.sgi.com
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20090102184232.GH28946@ZenIV.linux.org.uk>
References: <20081229041352.6bbdf57c@tpl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081229041352.6bbdf57c@tpl>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

Bloating with mutex is over the top, indeed, but why can't we simply keep
a pointer to fasync_struct in there?  Do we ever have a struct file with
several fasync_struct?  They'd have to be on different queues and I don't
see any cases where that would happen...
