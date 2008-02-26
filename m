Return-Path: <linux-kernel-owner+w=401wt.eu-S1763119AbYBZRDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763119AbYBZRDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761586AbYBZRDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:03:35 -0500
Received: from lazybastard.de ([212.112.238.170]:46416 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760820AbYBZRDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:03:34 -0500
Date: Tue, 26 Feb 2008 18:02:14 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Wedgwood <cw@f00f.org>
Subject: Re: Proposal for "proper" durable fsync() and fdatasync()
Message-ID: <20080226170214.GA23829@lazybastard.org>
References: <20080226072649.GB30238@shareable.org> <20080225234319.f4589ae4.akpm@linux-foundation.org> <20080226075921.GG30238@shareable.org> <200802262016.11297.nickpiggin@yahoo.com.au> <20080226140925.GB20428@lazybastard.org> <20080226152810.GB18118@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080226152810.GB18118@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 February 2008 15:28:10 +0000, Jamie Lokier wrote:
> 
> > One interesting aspect of this comes with COW filesystems like btrfs or
> > logfs.  Writing out data pages is not sufficient, because those will get
> > lost unless their referencing metadata is written as well.  So either we
> > have to call fsync for those filesystems or add another callback and let
> > filesystems override the default implementation.
> 
> Doesn't the ->fsync callback get called in the sys_fdatasync() case,
> with appropriate arguments?

My paragraph above was aimed at the sync_file_range() case.  fsync and
fdatasync do the right thing within the limitations you brought up in
this thread.  sync_file_range() without further changes will only write
data pages, not the metadata required to actually access those data
pages.  This works just fine for non-COW filesystems, which covers all
currently merged ones.

With COW filesystems it is currently impossible to do sync_file_range()
properly.  The problem is orthogonal to your's, I just brought it up
since you were already mentioning sync_file_range().


Jörn

-- 
Joern's library part 10:
http://blogs.msdn.com/David_Gristwood/archive/2004/06/24/164849.aspx
