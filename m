Return-Path: <linux-kernel-owner+w=401wt.eu-S1751302AbZG3IYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbZG3IYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 04:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZG3IYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 04:24:51 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:39130 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140AbZG3IYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 04:24:50 -0400
Subject: Re: [PATCH] kmemleak: Protect the seq start/next/stop sequence by
	rcu_read_lock()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090729170007.f4e60858.akpm@linux-foundation.org>
References: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com>
	 <20090729170007.f4e60858.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 30 Jul 2009 09:24:44 +0100
Message-Id: <1248942284.3376.2.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2009 08:24:45.0003 (UTC) FILETIME=[31AB79B0:01CA10EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-29 at 17:00 -0700, Andrew Morton wrote:
> On Wed, 29 Jul 2009 16:26:57 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
> 
> > Objects passed to kmemleak_seq_next() have an incremented reference
> > count (hence not freed) but they may point via object_list.next to
> > other freed objects. To avoid this, the whole start/next/stop sequence
> > must be protected by rcu_read_lock().
> > 
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> > 
> > This is a fix for bug #13761 in buzilla.kernel.org. If there are no
> > objections, please apply it before 2.6.31. Thanks.
> 
> Administrivia:
> 
> When referencing a bugzilla report, please quote the full URL within
> the changelog (not after the ^---$).  I use:
> 
> 	Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13761
> 
> This is because people ocassionally troll the commit logs, closing off
> bugzilla reports.  Using a standardised format simplifies that job, and
> makes it more reliable.
> 
> Also, it's nice to give the original bug reporter a Reported-by: in the
> changelog.  As a little thank-you, and so they know what's going on.

Yes, I agree. Thanks for adjusting these in the -mm tree patch.

-- 
Catalin

