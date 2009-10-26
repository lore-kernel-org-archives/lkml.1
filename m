Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZJZTbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZJZTbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 15:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbZJZTbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 15:31:42 -0400
Received: from [76.245.85.235] ([76.245.85.235]:55205 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbZJZTbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 15:31:41 -0400
Date: Mon, 26 Oct 2009 12:29:35 -0700
From: Brad Boyer <flar@allandria.com>
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Jamie Lokier <jamie@shareable.org>, Mark Fasheh <mfasheh@suse.com>,
       ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH 1/2] fiemap: Add new extent flag FIEMAP_EXTENT_SHARED
Message-ID: <20091026192935.GA12655@cynthia.pants.nu>
References: <1256173509-2831-1-git-send-email-sunil.mushran@oracle.com> <1256173509-2831-2-git-send-email-sunil.mushran@oracle.com> <20091023180034.GA11402@wotan.suse.de> <20091024183039.GB30762@shareable.org> <4AE5DC80.8010204@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE5DC80.8010204@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 10:29:36AM -0700, Sunil Mushran wrote:
> Jamie Lokier wrote:
> >It might be better to have a flag FIEMAP_EXTENT_NOT_SHARED.
> >
> >Apps which need to know the data is not shared can't safely check
> >!(flags & FIEMAP_EXTENT_SHARED) because of old kernels which don't set
> >the flag.
> 
> I'm probably not understanding your point. Won't the older kernels not set
> FIEMAP_EXTENT_NOT_SHARED too.
> 
> If this is important, we could always add this flag in the stable kernel
> trees. Both sharing of extents and fiemap are relatively new to the kernel.

I think the concern is that we are going to be getting "wrong" data when
using an old kernel, and the question is which type of error is safer. If
the flag is FIEMAP_EXTENT_SHARED, then programs running against an old
kernel may think that shared extents are not shared. If the flag is
instead FIEMAP_EXTENT_NOT_SHARED, then the program may think an extent is
shared when it is not.

The real question is which information is more important, to know that the
extent is shared or if the extent definitely is not shared. I would think
that having FIEMAP_EXTENT_SHARED is more consistent with the rest of the
defined bits, particularly since the program couldn't actually do anything
that relies completely on this data anyway since it could change at any
moment. It's not like the results of a map are static.

	Brad Boyer
	flar@allandria.com

