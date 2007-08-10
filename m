Return-Path: <linux-kernel-owner+w=401wt.eu-S937250AbXHJOnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937250AbXHJOnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762657AbXHJOnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:43:43 -0400
Received: from ns1.suse.de ([195.135.220.2]:33025 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786AbXHJOnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:43:42 -0400
Message-Id: <20070810142208.827949199@suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 10 Aug 2007 16:42:16 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, John Johansen <jjohansen@suse.de>,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
In-Reply-To: <20070808193209.GA31354@infradead.org>
References: <20070808171622.632749741@suse.de> <20070808171643.542685765@suse.de>
 <20070808193209.GA31354@infradead.org>
Subject: Re: [RFC 01/10] Split up struct nameidata
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Length: 2235
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 August 2007, Christoph Hellwig wrote:
> On Wed, Aug 08, 2007 at 07:16:23PM +0200, Andreas Gruenbacher wrote:
> > Split up struct nameidata into struct vfs_lookup with the lookup result
> > and intent and the remaining fields for performing an actual lookup.
> 
> Looks good as a start, but please don't put a struct path in there,
> as the vfsmount will go away from the lookup intent as soon as we have
> a new inode operation for atomic create + open, and not having it in the
> struct path will make that removal a lot less painfull.

Removing the vfsmount from struct vfs_intent sounds like a bad idea to
me. (dentry, vfsmount) pairs should be kept together; this makes it much
more obvious what's going on.

The idea of struct vfs_lookup is not a filesystem level abstraction and
information hiding mechanism, it is to be able to pass on a lookup
result to the vfs more easily. The vfsmount is definitely part of that
result. Cleaning up atomic create + open should be mostly independent of
that.

Attached are patches that introduce pathput() and pathget(). Those are
further cleanups which depend on the struct path in the nameidata /
vfs_lookup.

Thanks,
Andreas

