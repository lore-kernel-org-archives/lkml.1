Return-Path: <linux-kernel-owner+w=401wt.eu-S932337AbYD2QHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbYD2QHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbYD2QHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:07:37 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:48557 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbYD2QHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:07:33 -0400
Date: Tue, 29 Apr 2008 11:49:37 -0400
Message-Id: <200804291549.m3TFnb3H024733@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: bsn.0007@gmail.com
Cc: libc-alpha@sourceware.org, Jan Blunck <jblunck@suse.de>,
       Erez Zadok <ezk@cs.sunysb.edu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       Christoph Hellwig <hch@lst.de>, Ulrich Drepper <drepper@redhat.com>,
       Mingming Cao <cmm@us.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 0/2] Union Mount: Directory listing in glibc 
In-reply-to: Your message of "Tue, 29 Apr 2008 19:02:01 +0530."
             <20080429133201.GA9938@localhost.localdomain> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080429133201.GA9938@localhost.localdomain>, bsn.0007@gmail.com writes:
> Hi,
> 
> I went through Bharata's RFC post on glibc based Union Mount readdir solution
> (http://lkml.org/lkml/2008/3/11/34) and have come up with patches
> against glibc to implement the same.
[...]

The last set of discussions on glibc support ended, as I understood it, with
the glibc people objecting to such "special-purpose" code in glibc.  See
<http://lkml.org/lkml/2008/3/11/66>.  So has anything changed behind the
scenes, or is this idea unlikely to be merged into glibc any time soon, if
ever.  (Personally I'd love to rip out the readdir-related code from unionfs
if glibc supported the same.)

> Patch 1. readdir support for union mounted directories.
> 	I am caching the dirent names in a list to aid duplicate elimination.
> And this cache is stored in DIRP. For duplicate elimination I am using
> strcmp(). I am not sure if this works universally with different types
> of filesystems. Any suggestions here would be welcome.
[...]

You might consider using a hash table instead of a list; it'll be faster in
case where there are a lot of whiteouts/duplicates to process.


Also, I'll reiterate my previous concern that I think you may need to also
handle "opaque directories".  See the discussion in section 5.1 "Creation
and deletion of whiteouts", in the original union mounts paper:

<http://www.usenix.org/publications/library/proceedings/neworl/full_papers/mckusick.a>

Cheers,
Erez.
