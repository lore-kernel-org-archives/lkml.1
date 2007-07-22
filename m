Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbXGVCSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbXGVCSG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 22:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754798AbXGVCRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 22:17:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:35778 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbXGVCRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 22:17:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,567,1175497200"; 
   d="scan'208";a="253198714"
Subject: Re: [linux-pm] Re: Hibernation considerations
From: "Huang, Ying" <ying.huang@intel.com>
To: david@lang.hm
Cc: Milton Miller <miltonm@bga.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J.Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
In-Reply-To: <Pine.LNX.4.64.0707200845200.19248@asgard.lang.hm>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
	 <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
	 <200707172217.01890.rjw@sisk.pl> <87odiag45q.fsf@jbms.ath.cx>
	 <200707151433.34625.rjw@sisk.pl> <200707172320.16279.rjw@sisk.pl>
	 <40fa2626aff7b6b590ad6aa4737fc873@bga.com>
	 <1184942918.13737.23.camel@caritas-dev.intel.com>
	 <Pine.LNX.4.64.0707200845200.19248@asgard.lang.hm>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 22 Jul 2007 10:17:14 +0800
Message-Id: <1185070634.3517.11.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 22 Jul 2007 02:17:50.0118 (UTC) FILETIME=[80815C60:01C7CC06]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 08:48 -0700, david@lang.hm wrote:
> > Backuping target memory before kexec and restoring it after kexec is
> > planed feature for kexec jump. But I will work on image writing/reading
> > first.
> 
> if we can get a list of what memory is safe to backup/restore then the 
> reading/writing of the image should be able to be done in userspace.

The backup/restore here has nothing to do with the read/write of the
image. It means instead of preserving memory for a new kernel like that
of crash-dump, the memory for a new kernel is backupped before kexec and
restored after kexec by the kexec kernel.

> > If the "scatter copy" is replaced by "scatter swap", we need not the
> > inverse list, and the state of kexeced kernel can be backuped too. There
> > are "scatter copy" support in normal kexec implementation in
> > "relocate_kernel".
> 
> what do you mean by "scatter swap"

copy:	dest=src
swap:	tmp=dest; dest=src; src=tmp

If memory is swapped, no information is lost, both that of kexec kernel
and kexeced kernel.

Best Regards,
Huang, Ying
