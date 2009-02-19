Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbZBSMSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbZBSMSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:18:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752743AbZBSMSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:18:04 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:26703 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752447AbZBSMSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:18:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iF3f/tumuY49uxr9kHtb3lEOZsM20k6KYXdfhPf+f9uA66fSRFlvS9DwJDJUwN7M1AlwUnln3mhHh279Y31J6CUyTmhF2iNzpuL/K6eck+Uu6LdzQWoI9szPoihYj/uzJ+6FqcpitM657oZYFefZEFk2By9SulrkkpLsQ4+tUk4=  ;
X-YMail-OSG: jDabtUcVM1mUAW2p6XiGYuQWZx_NxCdz3ciT5Toy1PgxWzAckHHJD7.7_KEcmCjWck.p3JcBq4iFbYvVgK3Fp0_NEgj_5txm.A6ChFgb8azU8ZjP_9x0aZN1L9rO_lpWBGlYI99TMivvcUNgWRrfjyYZQV4sg3iz.StFL6FYcOvGtap8G6Q9vkGfIOtr
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/10] vmalloc: add un/map_kernel_range_noflush()
Date: Thu, 19 Feb 2009 23:17:27 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, mingo@elte.hu
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <1234958676-27618-9-git-send-email-tj@kernel.org>
In-Reply-To: <1234958676-27618-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902192317.28696.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 23:04:34 Tejun Heo wrote:
> Impact: two more public map/unmap functions
>
> Implement map_kernel_range_noflush() and unmap_kernel_range_noflush().
> These functions respectively map and unmap address range in kernel VM
> area but doesn't do any vcache or tlb flushing.  These will be used by
> new percpu allocator.

Hmm... I have no real issues with this, although the caller is going
to have to be very careful not to introduce bugs (which I'm sure you
were ;)).

Maybe can you add comments specifying the minimum of which flushes
are required and when, to scare people away from using them?


>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  include/linux/vmalloc.h |    3 ++
>  mm/vmalloc.c            |   58
> ++++++++++++++++++++++++++++++++++++++++++++-- 2 files changed, 58
> insertions(+), 3 deletions(-)

