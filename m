Return-Path: <linux-kernel-owner+w=401wt.eu-S1759911AbYD3GH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759911AbYD3GH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 02:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757717AbYD3GHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 02:07:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:37564 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbYD3GHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 02:07:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=v4ZTahqqPwPXUR6bhx+3gliUSN9BE73eHMH9w4bHjfvlLDXQXa4Zgp4hq/z2j1UCQ5fKDv2JEr0868fR3DZa7sgAobq9XP3uaKAiIly2FbMt2n32Dy1qeENyG8LNqAmEykdydbFdPpB0PLucz44kn/EUUc4+cZUs16XuoZTxHlM=
Message-ID: <c810d5090804292307y2884b169t5c27b50fb7c94c30@mail.gmail.com>
Date: Wed, 30 Apr 2008 11:37:10 +0530
From: "NAGABHUSHAN BS" <bsn.0007@gmail.com>
To: "Erez Zadok" <ezk@cs.sunysb.edu>
Subject: Re: [RFC PATCH 0/2] Union Mount: Directory listing in glibc
Cc: libc-alpha@sourceware.org, "Jan Blunck" <jblunck@suse.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, "Christoph Hellwig" <hch@lst.de>,
       "Ulrich Drepper" <drepper@redhat.com>, "Mingming Cao" <cmm@us.ibm.com>,
       "Dave Hansen" <haveblue@us.ibm.com>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <200804291549.m3TFnb3H024733@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429133201.GA9938@localhost.localdomain>
	 <200804291549.m3TFnb3H024733@agora.fsl.cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 9:19 PM, Erez Zadok <ezk@cs.sunysb.edu> wrote:
> In message <20080429133201.GA9938@localhost.localdomain>, bsn.0007@gmail.com writes:
>  > Hi,
>  >
>  > I went through Bharata's RFC post on glibc based Union Mount readdir solution
>  > (http://lkml.org/lkml/2008/3/11/34) and have come up with patches
>  > against glibc to implement the same.
>  [...]
>
>  The last set of discussions on glibc support ended, as I understood it, with
>  the glibc people objecting to such "special-purpose" code in glibc.  See
>  <http://lkml.org/lkml/2008/3/11/66>.  So has anything changed behind the
>  scenes, or is this idea unlikely to be merged into glibc any time soon, if
>  ever.  (Personally I'd love to rip out the readdir-related code from unionfs
>  if glibc supported the same.)
>
>
>  > Patch 1. readdir support for union mounted directories.
>  >       I am caching the dirent names in a list to aid duplicate elimination.
>  > And this cache is stored in DIRP. For duplicate elimination I am using
>  > strcmp(). I am not sure if this works universally with different types
>  > of filesystems. Any suggestions here would be welcome.
>  [...]
>
>  You might consider using a hash table instead of a list; it'll be faster in
>  case where there are a lot of whiteouts/duplicates to process.
>

Yes, hash table was one of the things i had considered  to use as a
cache. But i am not completely sure how this would support seekdir.
Any suggestions are greatly welcome.

Regards Nagabhushan
