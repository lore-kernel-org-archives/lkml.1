Return-Path: <linux-kernel-owner+w=401wt.eu-S1031280AbXDJRgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031280AbXDJRgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 13:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031279AbXDJRga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 13:36:30 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:41530 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031270AbXDJRg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 13:36:29 -0400
Date: Tue, 10 Apr 2007 13:35:52 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Shaya Potter <spotter@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL -mm] Unionfs branch management code
Message-ID: <20070410173552.GB9105@filer.fsl.cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu> <20070409104948.2bc99202.akpm@linux-foundation.org> <461BC7EC.5080101@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <461BC7EC.5080101@cs.columbia.edu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 01:22:52PM -0400, Shaya Potter wrote:
> Andrew Morton wrote:
> >On Mon,  9 Apr 2007 10:53:51 -0400 "Josef 'Jeff' Sipek" 
> ><jsipek@cs.sunysb.edu> wrote:
> >
> >>The following patches introduce new branch-management code into Unionfs as
> >>well as fix a number of stability issues and resource leaks.
> >
> >I have a mental note that unionfs is in the "stuck" state, due to general
> >agreement that we should implement this functionality at the VFS level, one
> >reason for which is unionfs's upper-vs-lower coherency problems.
> 
> How can a union file system with a decent set of useful semantics be 
> fully implemented at the VFS layer in a "clean" manner?

Unioning is quite odd. It uses concepts, some of which do indeed belong in
the VFS (like actual merging of the lower directories), but others that most
definitely do not (like whiteouts).

> For instance, a major use of unionfs is live CDs, namely unionfs w/ a 
> read-only and read-write layer.  Unionfs enables files to be copied up 
> from the read-only layer to the read-write layer.
> 
> Does one really want to implement "copyup" in the VFS?
 
I don't think that copyup is the problem, but whiteouts...oh boy.
Whiteouts/some kind of persistent storage is most definitely a filesystem
construct, and it does not belong in the VFS.

Josef "Jeff" Sipek.

-- 
If I have trouble installing Linux, something is wrong. Very wrong.
		- Linus Torvalds
