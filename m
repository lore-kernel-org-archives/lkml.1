Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYCNFkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYCNFkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbYCNFk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:40:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37334 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbYCNFk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:40:26 -0400
Date: Fri, 14 Mar 2008 05:39:25 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: bharata@linux.vnet.ibm.com, libc-alpha@sourceware.org,
       Jan Blunck <jblunck@suse.de>, Erez Zadok <ezk@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [RFC] Union mount readdir support in glibc
Message-ID: <20080314053925.GA10722@ZenIV.linux.org.uk>
References: <20080311055527.GA7256@in.ibm.com> <47D9F6CC.6010009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D9F6CC.6010009@redhat.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 08:53:48PM -0700, Ulrich Drepper wrote:

> To handle union FS at userlevel somewhere in that code sequence (perhaps
> in the fstat call) we'd have to recognize such mounts.

*Snort*

How about "the first entry returned by getdents(3) after open() is a whiteout
for e.g. '.'"?  No fstat needed, zero impact for normal directories,
zero impact for any binaries on old kernels (where you wouldn't have
unions) and zero impact for old binaries on new kernels unless they
do getdents() on directory that happens to be a union.

And no lockstep...

>  Before any
> agreement on userlevel sorting can be made you'll have to answer a
> question Roland already asked:
> 
> - - How does this work with NFS?

It won't, kernel-side or done in userland.

> re seeking: you have to support seeking.  There is no way around it.

Actually, do we really need it other than to 0 and to current position
(i.e. full rewind and a no-op)?
