Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYCNPHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYCNPHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 11:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYCNPHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 11:07:36 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:52992 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753020AbYCNPHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 11:07:35 -0400
Date: Fri, 14 Mar 2008 16:07:12 +0100
From: Jan Blunck <jblunck@suse.de>
To: Ulrich Drepper <drepper@redhat.com>
Cc: bharata@linux.vnet.ibm.com, libc-alpha@sourceware.org,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Mingming Cao <cmm@us.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [RFC] Union mount readdir support in glibc
Message-ID: <20080314150638.GA27730@T61>
References: <20080311055527.GA7256@in.ibm.com> <47D9F6CC.6010009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D9F6CC.6010009@redhat.com>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG
	Nuernberg)
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, Ulrich Drepper wrote:

> There is very little overhead.  Since we copy using getdents multiple
> records it is more efficient than implementing readdir in the kernel.
> This is how efficient normal directory operations must remain.  The only
> slight inefficiency is that we have to copy the entries after getdents()
> because the d_type field is not in the place we expect it at userlevel.
>  For this a new interface could help.

BTW, Since some filesystem always give DT_UNKNOWN an additional stat is
necessary to implement whiteout filtering. I don't want to do that in
kernel-space if possible ...

> Regarding questions you have: if a directory currently is read and file
> are added or removed, all bets are off.
> 
> re seeking: you have to support seeking.  There is no way around it.
> Once again, if any file has been added/removed, all bets are off.  So,
> why not provide a cookie similar to what is done today?  I think it is
> not acceptable to require caching the entire directory content at
> userlevel.  It's bad enough if we have to store the file names for
> duplicate elimination.

Which basically means tracking of the "space" between dirents and maintaining
the relative order of entries. Which is a pain. I already tried to solve this
problem for tmpfs before and it needs a hugh amount of kernel memory for open
directories. In the end I only know of one situation where it is used: very old
glibc when running 32bit applications on 64bit kernel.

Cheers,
Jan
