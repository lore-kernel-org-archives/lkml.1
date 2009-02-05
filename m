Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZBEFKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZBEFKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 00:10:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbZBEFKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 00:10:06 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:16751 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZBEFKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 00:10:04 -0500
X-IronPort-AV: E=Sophos;i="4.37,383,1231113600"; 
   d="scan'208";a="138065985"
From: Roland Dreier <rdreier@cisco.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eli Cohen <eli@mellanox.co.il>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
References: <20090203164930.GA10101@mtls03> <ada8wonnh3t.fsf@cisco.com>
	<1233712248.16867.131.camel@pasglop>
	<20090203211329.d6190a08.akpm@linux-foundation.org>
	<aday6wmn2vr.fsf@cisco.com>
	<20090203222601.747ca8b7.akpm@linux-foundation.org>
	<adad4dym2zp.fsf@cisco.com> <1233791729.4612.28.camel@pasglop>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 04 Feb 2009 21:10:02 -0800
In-Reply-To: <1233791729.4612.28.camel@pasglop> (Benjamin Herrenschmidt's
	message of "Thu, 05 Feb 2009 10:55:29 +1100")
Message-ID: <ada7i45lb9x.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Feb 2009 05:10:03.0312 (UTC) FILETIME=[008CA300:01C98750]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Note that g_u_p() has all sort of shortcommings... we were discussing
 > some of that recently due to bugs reported from the field.
 > 
 > The problem mostly is that you cannot guarantee that the physical page
 > will remain mapped to that virtual address in the process. For example,
 > if your code is part of some library used by an application, and that
 > application somewhere does a fork/exec (for example, a system() call to
 > run a shell helper), copy-on-write will hit, and you may end up with
 > the child process getting the original physical page and the original
 > process getting the copy...

Believe me, I'm well aware of that.  We added VM_DONTCOPY to allow apps
to fork() without the child triggering COW, but that means only the
parent process can use the mapped memory (and the app has to worry about
page boundaries etc).

 > We've been discussing that at KS with various people, Linus says g_u_p()
 > sucks, don't do that :-) Most of the time, the other approach should be
 > used, ie, the driver allocates memory, and userspace mmap's it, in which
 > case you get access to the VMA to set flags such as don't copy on fork.

Yes, but unfortunately MPI says apps can allocate memory however they
damn well please... in any case these issues are all-too-well-known in
the RDMA world for quite a while.

Thanks,
  Roland

