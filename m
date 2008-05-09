Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbYEIUpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbYEIUpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbYEIUpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:45:05 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:39119 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbYEIUpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:45:02 -0400
Date: Fri, 9 May 2008 16:05:54 -0400
Message-Id: <200805092005.m49K5s4N014510@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: bharata@linux.vnet.ibm.com
Cc: Ulrich Drepper <drepper@redhat.com>, bsn.0007@gmail.com,
       libc-alpha@sourceware.org, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 1/2] Union Mount: glibc readdir support 
In-reply-to: Your message of "Tue, 06 May 2008 09:51:17 +0530."
             <20080506042117.GA29298@in.ibm.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080506042117.GA29298@in.ibm.com>, Bharata B Rao writes:
> On Wed, Apr 30, 2008 at 11:08:41PM -0700, Ulrich Drepper wrote:
> > 
> > Before anything further is discussed I need to know how you expect to
> > handle NFS?  I don't see how, with a userlevel readdir implementation,
> > you can support NFS.
> 
> At the client side, I don't see a problem with unioning NFS with other
> FS. Kernel would still return all dirents of the union including those
> from NFS and glibc readdir would be able to handle them appropriately.
> Or am I missing something ?
> 
> At the server side, I can't see how NFS server could export a union.
> I don't see how this could be sanely done with Union Mount. Erez, how
> does Unionfs handle this ?
[...]

The ODF version of unionfs stores, among other things, persistent inode
numbers in a small/special /odf partition.  If the inums aren't persistent,
they could get flushed out of memory, making it very difficult to
reconstruct the inode w/ the same inum later on.

Erez.
