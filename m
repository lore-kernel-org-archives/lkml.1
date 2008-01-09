Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbYAILz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbYAILz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYAILzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:55:14 -0500
Received: from [212.12.190.220] ([212.12.190.220]:42387 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750756AbYAILzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:55:12 -0500
From: Al Boldi <a1426z@gawab.com>
To: "Valerie Henson" <val.henson@gmail.com>
Subject: Re: [RFD] Incremental fsck
Date: Wed, 9 Jan 2008 14:52:14 +0300
User-Agent: KMail/1.5
Cc: "Rik van Riel" <riel@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200801090022.55589.a1426z@gawab.com> <200801090740.12989.a1426z@gawab.com> <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com>
In-Reply-To: <70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801091452.14890.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valerie Henson wrote:
> On Jan 8, 2008 8:40 PM, Al Boldi <a1426z@gawab.com> wrote:
> > Rik van Riel wrote:
> > > Al Boldi <a1426z@gawab.com> wrote:
> > > > Has there been some thought about an incremental fsck?
> > > >
> > > > You know, somehow fencing a sub-dir to do an online fsck?
> > >
> > > Search for "chunkfs"
> >
> > Sure, and there is TileFS too.
> >
> > But why wouldn't it be possible to do this on the current fs
> > infrastructure, using just a smart fsck, working incrementally on some
> > sub-dir?
>
> Several data structures are file system wide and require finding every
> allocated file and block to check that they are correct.  In
> particular, block and inode bitmaps can't be checked per subdirectory.

Ok, but let's look at this a bit more opportunistic / optimistic.

Even after a black-out shutdown, the corruption is pretty minimal, using 
ext3fs at least.  So let's take advantage of this fact and do an optimistic 
fsck, to assure integrity per-dir, and assume no external corruption.  Then 
we release this checked dir to the wild (optionally ro), and check the next.  
Once we find external inconsistencies we either fix it unconditionally, 
based on some preconfigured actions, or present the user with options.

All this could be per-dir or using some form of on-the-fly file-block-zoning.

And there probably is a lot more to it, but it should conceptually be 
possible, with more thoughts though...

> http://infohost.nmt.edu/~val/review/chunkfs.pdf


Thanks!

--
Al

