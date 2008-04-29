Return-Path: <linux-kernel-owner+w=401wt.eu-S1763183AbYD2QMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763183AbYD2QMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYD2QMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:12:39 -0400
Received: from mx1.suse.de ([195.135.220.2]:58927 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbYD2QMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:12:38 -0400
Date: Tue, 29 Apr 2008 18:12:37 +0200
From: Jan Blunck <jblunck@suse.de>
To: hooanon05@yahoo.co.jp
Cc: bsn.0007@gmail.com, libc-alpha@sourceware.org,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Ulrich Drepper <drepper@redhat.com>,
       Mingming Cao <cmm@us.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 0/2] Union Mount: Directory listing in glibc
Message-ID: <20080429161237.GZ30780@bolzano.suse.de>
References: <20080429133201.GA9938@localhost.localdomain> <9167.1209482469@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9167.1209482469@jrobl>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, hooanon05@yahoo.co.jp wrote:

> 
> Hello Nagabhushan,
> 
> bsn.0007@gmail.com:
> > I went through Bharata's RFC post on glibc based Union Mount readdir solution
> > (http://lkml.org/lkml/2008/3/11/34) and have come up with patches
> > against glibc to implement the same.
> 	:::
> 
> While I don't have objection against the implementation in userspace,
> what will UnionMount handle about rmdir or rename dir?
> Those systemcalls need to test whether the dir is *logically* empty or
> not in kernel space, don't they?
> And I am afraid that UnionMount has to implement the similar thing, but
> it never mean to modify glibc is a bad idea.

For rmdir it is simple: the filesystem that supports whiteouts must know how
to get rid of them again. Since it knows how the whiteouts are implemented it
can do that in an optimized fashion.

The rename story is somehow different. A union directory consists of multiple
directories on different filesystem. Since rename syscall is only working on
one filesystem the rename is crossing devices. Therefore I return -EXDEV. Not
very efficient but really simple. At least this is how my patches implement it.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
