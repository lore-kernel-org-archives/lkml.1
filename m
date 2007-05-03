Return-Path: <linux-kernel-owner+w=401wt.eu-S1161831AbXECKx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161831AbXECKx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 06:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161838AbXECKx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 06:53:27 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:38165 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161831AbXECKx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 06:53:26 -0400
X-IronPort-AV: i="4.14,485,1170651600"; 
   d="scan'208"; a="37292636:sNHT33525184"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg Ungerer" <gerg@snapgear.com>
Subject: Re: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
Date: Thu, 3 May 2007 06:55:36 -0400
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <46382055.8030203@snapgear.com> <200705020458.06595.rgetz@blackfin.uclinux.org> <463876BA.9020005@snapgear.com>
In-Reply-To: <463876BA.9020005@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705030655.36957.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 03 May 2007 10:53:24.0706 (UTC) FILETIME=[45E8E420:01C78D71]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2 May 2007 07:32, Greg Ungerer pondered:
> Robin Getz wrote:
> > On Wed 2 May 2007 01:23, Greg Ungerer pondered:
> >> diff -Naur linux-2.6.21/fs/namei.c linux-2.6.21-uc0/fs/namei.c
> >> --- linux-2.6.21/fs/namei.c     2007-05-01 17:12:53.000000000 +1000
> >> +++ linux-2.6.21-uc0/fs/namei.c 2007-05-01 17:16:18.000000000 +1000
> >> @@ -120,12 +120,14 @@
> >>         int retval;
> >>         unsigned long len = PATH_MAX;
> >>
> >> +#ifdef CONFIG_MMU
> >>         if (!segment_eq(get_fs(), KERNEL_DS)) {
> >>                 if ((unsigned long) filename >= TASK_SIZE)
> >>                         return -EFAULT;
> >>                 if (TASK_SIZE - (unsigned long) filename < PATH_MAX)
> >>                         len = TASK_SIZE - (unsigned long) filename;
> >>         }
> >> +#endif
> >>
> >>         retval = strncpy_from_user(page, filename, len);
> >>         if (retval > 0) {
> >
> > I was trying to understand why we don't want to do the same checking on
> > noMMU?
>
> The problem is on systems that have RAM mapped at high physical
> addresses. TASK_SIZE may well be a numerically smaller number
> than the address range that RAM sits in. So this test fails when
> it shouldn't.

So, then this is a problem only on one or two architectures, not all noMMU 
platforms?

-Robin
