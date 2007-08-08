Return-Path: <linux-kernel-owner+w=401wt.eu-S937436AbXHHR2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937436AbXHHR2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 13:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbXHHR2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 13:28:13 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35591 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532AbXHHR2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 13:28:12 -0400
Date: Wed, 8 Aug 2007 19:28:21 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] remove binfmts.h from header exports
Message-ID: <20070808172821.GA3654@aepfle.de>
References: <20070807201603.GB31501@aepfle.de> <20070807203707.GB5844@martell.zuzino.mipt.ru> <20070808061439.GB1126@aepfle.de> <b6fcc0a0708080012w1794ad84ma2a3b5a84eb5b8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b6fcc0a0708080012w1794ad84ma2a3b5a84eb5b8b@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, Alexey Dobriyan wrote:

> > > And? Does it contain stuff which is userspace visible?
> > > binfmts.h has at least CORENAME_MAX_SIZE and SUID_DUMP_*
> >
> > Yes, its inside __KERNEL__.
> 
> Can't you accept for a second that some stuff under __KERNEL__
> was put there by mistake?

I wonder why the defines exist at all? My grep doesnt find SUID_DUMP_*.
Looking at the commit message from d6e711448137ca3301512cec41a2c2ce852b3d0a

...
    > >         if (current->euid == current->uid && current->egid == current->gid)
    > >                 current->mm->dumpable = 1;
    >
    > Should this be SUID_DUMP_USER?

    Actually the feedback I had from last time was that the SUID_ defines
    should go because its clearer to follow the numbers. They can go
    everywhere (and there are lots of places where dumpable is tested/used
    as a bool in untouched code)
...

Exporting a random array size is not very useful. The app and the kernel
has to check the string length anyway.

So lets remove the header and the 3 unused defines.
