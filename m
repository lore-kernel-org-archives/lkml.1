Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbXI0Pk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbXI0Pk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 11:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbXI0Pj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 11:39:59 -0400
Received: from mail.fieldses.org ([66.93.2.214]:45433 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894AbXI0Pj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 11:39:58 -0400
Date: Thu, 27 Sep 2007 11:39:56 -0400
To: nfs@lists.sourceforge.net, nfsv4@linux-nfs.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: NFS server development update
Message-ID: <20070927153956.GF2522@fieldses.org>
References: <20070927153233.GE2522@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927153233.GE2522@fieldses.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 11:32:33AM -0400, J. Bruce Fields wrote:
> I'll follow up with a summary of the patches I currently have.

... but this time around that's nothing major--mostly just small
bugfixes and cleanup, including 64 bit inode support from Peter Staubach
and some preparation for supporting callbacks (hence delegations) over
krb5.

One outstanding question is what to do about the server RDMA and
transport-switch code, not yet included below.  It would nice to finally
see that start going in, but it's a lot of code to add this late.

--b.

>From git://linux-nfs.org/~bfields/linux.git nfs-server-stable:

Andrew Morton (1):
      nfsd warning fix

Christoph Hellwig (1):
      nfsd: fix horrible indentation in nfsd_setattr

Dr. David Alan Gilbert (1):
      knfsd: Add source address to sunrpc svc errors

J. Bruce Fields (14):
      nfsd: tone down inaccurate dprintk
      nfsd: remove unused cache_for_each macro
      knfsd: delete code made redundant by map_new_errors
      knfsd: cleanup of nfsd4 cmp_* functions
      knfsd: demote some printk()s to dprintk()s
      knfsd: nfs4 name->id mapping not correctly parsing negative downcall
      knfsd: spawn kernel thread to probe callback channel
      knfsd: move nfsv4 slab creation/destruction to module init/exit
      knfsd: fix callback rpc cred
      knfsd: remove code duplication in nfsd4_setclientid()
      svcgss: move init code into separate function
      knfsd: let nfsd manage timing out its own leases
      knfsd: don't shutdown callbacks until nfsv4 client is freed
      knfsd: nfsv4 delegation recall should take reference on client

Peter Staubach (1):
      knfsd: 64 bit ino support for NFS server

