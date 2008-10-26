Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbYJZAIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbYJZAIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 20:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYJZAIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 20:08:12 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:2776 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754401AbYJZAIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 20:08:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4DAM8S9kh5LE2tgWdsb2JhbACTYAEBFiKuDIFr
X-IronPort-AV: E=Sophos;i="4.33,486,1220193000"; 
   d="scan'208";a="218117219"
Date: Sun, 26 Oct 2008 11:08:04 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Tiago Maluta <maluta_tiago@yahoo.com.br>
Subject: Re: [Bug #11805] mounting XFS produces a segfault
Message-ID: <20081026000804.GC11948@disturbed>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Tiago Maluta <maluta_tiago@yahoo.com.br>
References: <nw2Y6lk-0lG.A.VUB.RV5AJB@chimera> <t1C3RWL0r7M.A.x6C.AW5AJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <t1C3RWL0r7M.A.x6C.AW5AJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 10:06:44PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11805
> Subject		: mounting XFS produces a segfault
> Submitter	: Tiago Maluta <maluta_tiago@yahoo.com.br>
> Date		: 2008-10-21 18:00 (5 days old)

Ah - this was reported as a 2.6.26 -> 2.6.27 regression, not a
.27->.28-rcX regression.

Even so, it's not obviously an XFS regression as the problem is
that alloc_pages(GFP_KERNEL) is the new failure on .27. The fact
that XFS never handled the allocation failure is not a new bug
or regression - it has never caught failures during log
allocation...

So really, if you want to look for a regression here, it is the
change of behaviour in the VM leading to a memory allocation failure
where it has never, ever previously failed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
