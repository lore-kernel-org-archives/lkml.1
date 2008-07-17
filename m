Return-Path: <linux-kernel-owner+w=401wt.eu-S1761139AbYGQWkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761139AbYGQWkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758965AbYGQWkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:40:19 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:16652 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758280AbYGQWkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:40:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjwBADBmf0h5LFxAiGdsb2JhbACSPQEBAQ8gngk
X-IronPort-AV: E=Sophos;i="4.31,205,1215354600"; 
   d="scan'208";a="151816808"
Date: Fri, 18 Jul 2008 08:40:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, Tim Shimmin <xfs-masters@oss.sgi.com>,
       xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
       Johannes Weiner <hannes@saeurebad.de>
Subject: Re: latest -git: kernel BUG at fs/xfs/support/debug.c:54!
Message-ID: <20080717224012.GH29319@disturbed>
Mail-Followup-To: Vegard Nossum <vegard.nossum@gmail.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Tim Shimmin <xfs-masters@oss.sgi.com>, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org, Johannes Weiner <hannes@saeurebad.de>
References: <19f34abd0807171046j425bebc6m8d8eb80a641e0e5b@mail.gmail.com> <487F980F.7070708@redhat.com> <19f34abd0807171218u3de86ddbt506b0b4fa0548406@mail.gmail.com> <19f34abd0807171229p724cc44ese3cb064a65fbd2c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807171229p724cc44ese3cb064a65fbd2c0@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 09:29:39PM +0200, Vegard Nossum wrote:
> On Thu, Jul 17, 2008 at 9:18 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > Thanks, you are right. I have adjusted my configuration, but I am
> > still able to produce this:
> >
> > BUG: unable to handle kernel paging request at b62a66e0
> > IP: [<c030ef88>] xfs_alloc_fix_freelist+0x28/0x490
> 
> FWIW, this is fs/xfs/xfs_alloc.c:1817:
> 
>         if (!pag->pagf_init) {

Which kind of implies that we've got a bogus fsbno
that we're using as the basis of allocation.....

What is the corruption you are inducing? Can you produce
a xfs_metadump image of the filesystem and put it up somewhere
that we can access it?

I suspect that we are not validating the block numbers coming
out of the various btrees as landing inside the filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
