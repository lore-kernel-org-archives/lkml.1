Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbXGaJgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbXGaJgB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXGaJfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:35:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:16219 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbXGaJfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kJXzKQ5qqGqfRr6mk6JfFjpzkfTUNDKPoeXiakSnqAHEx/eeolROme6nHXMm0AKFnO+pDZK/kAF+bOS34nYpDduSCjcpQWevmt0Z+WbH/r3Z/UXjjaM5zkIw9GwrBEvMDMIE6KyHzx1je+jRbEQj8JP5ZKEWRKbfPDY6dSkgCIU=
Message-ID: <91b13c310707310235u3a911ab7maf9b4e5ded99e179@mail.gmail.com>
Date: Tue, 31 Jul 2007 17:35:36 +0800
From: "rae l" <crquan@gmail.com>
To: "Steven Whitehouse" <swhiteho@redhat.com>
Subject: Re: [PATCH] fs/gfs2: mark struct *_operations const
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org, chdebra@gmail.com
In-Reply-To: <1185873464.8765.564.camel@quoit>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11858607771757-git-send-email-crquan@gmail.com>
	 <1185873464.8765.564.camel@quoit>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Hi,
>
> On Tue, 2007-07-31 at 13:46 +0800, Denis Cheng wrote:
> > these struct *_operations are all method tables, thus should be const.
> >
> > Signed-off-by: Denis Cheng <crquan@gmail.com>
> > ---
> >  fs/gfs2/eaops.c        |    8 ++++----
> >  fs/gfs2/eaops.h        |    4 ++--
> >  fs/gfs2/glock.c        |    2 +-
> >  fs/gfs2/ops_dentry.c   |    3 +--
> >  fs/gfs2/ops_dentry.h   |    2 +-
> >  fs/gfs2/ops_vm.c       |    4 ++--
> >  fs/gfs2/ops_vm.h       |    4 ++--
> >  include/linux/dcache.h |    2 +-
> >  include/linux/mm.h     |    2 +-
> >  9 files changed, 15 insertions(+), 16 deletions(-)
> >
>
> In general this looks good, however where you have made changes in the
> two include files dcache.h and mm.h be aware that other filesystems also
> use these and I suspect there are more places to change than just gfs2.
> Can you do a test build with all filesystems enabled to ensure that
> you've got all the places which can then be marked const? OCFS2, to take
> one example, has a vm_operations_struct which would need to be updated
> on that basis at least.
>
> In fact if you can break this up into a patch which affects only gfs2
> (which I can apply right away) and a patch which affects the core, plus
> updates for the various filesytems that would probably make things
> easier from the merging point of view. Since the latter would affect
> multiple filesystems, it would make sense to push it through -mm rather
> than for me to put it in my git tree,
>
> Steve.
>

I think so. But I've tested it under x86(pentium4) with allyesconfig
and allmodconfig, the compilication process of the kernel looked very
quiet.
$ make mrproper
$ make allyesconfig
$ make fs/

$ make mrproper
$ make allmodconfig
$ make fs/

and the ocfs2 didn't complain.

However, I'll split it into two patches and resend them later.
