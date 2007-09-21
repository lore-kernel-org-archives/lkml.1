Return-Path: <linux-kernel-owner+w=401wt.eu-S1758691AbXIUMrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691AbXIUMrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbXIUMre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:47:34 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56882 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbXIUMrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:47:33 -0400
Date: Fri, 21 Sep 2007 08:47:27 -0400
To: Chakri n <chakriin5@gmail.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: NFS on loopback locks up entire system(2.6.23-rc6)?
Message-ID: <20070921124727.GA15108@fieldses.org>
References: <92cbf19b0709201722k6265e647x31b7d25bc54b63a0@mail.gmail.com> <1190335423.6763.180.camel@heimdal.trondhjem.org> <92cbf19b0709202012s375c6f54m588987b4bbf552bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92cbf19b0709202012s375c6f54m588987b4bbf552bc@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 08:12:34PM -0700, Chakri n wrote:
> And unfortunately in my case, I cannot use "mount --bind". I want to
> use the same file system from two different nodes, and I want file &
> record locking to be consistent. The only way to make sure locking is
> consistent is to use loopback NFS on 1 host and NFS mount the same
> file system on other nodes, so that NFS server ensures file & record
> locking to be consistent. Is there any alternative to this?

The NFS server acquires a lock on the exported filesystem before
granting it to an NFS client, so loopback mounting shouldn't add any
extra safety.  If you've witnessed some exception to this rule, please
let us know.

> Is it possible or any efforts to integrate ext3 or other local file
> systems locking & network file system locking, so that user can use
> "mount --bind" on local host and NFS mount on remote nodes, but file &
> record locking will be consistent between both the nodes?

That's the way it works already, more or less.

(It depends a little on what you mean by "file and record locking".  The
byte-range locks acquired by fcntl() have always been enforced over NFS.
Locks acquired by flock() haven't always been, but loopback mounting
doesn't solve this problem.)

--b.
