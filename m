Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbYHHLkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbYHHLkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbYHHLju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:39:50 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:54069 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757122AbYHHLjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:39:49 -0400
Date: Fri, 08 Aug 2008 20:39:44 +0900 (JST)
Message-Id: <20080808.203944.29203232.taka@valinux.co.jp>
To: fernando@oss.ntt.co.jp
Cc: balbir@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
       uchida@ap.jp.nec.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@sourceware.org, dave@linux.vnet.ibm.com,
       ngupta@google.com, righi.andrea@gmail.com
Subject: Re: RFC: I/O bandwidth controller
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <1218078075.3803.149.camel@sebastian.kern.oss.ntt.co.jp>
References: <1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
	<4899D464.1070506@linux.vnet.ibm.com>
	<1218078075.3803.149.camel@sebastian.kern.oss.ntt.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > Would you like to split up IO into read and write IO. We know that read can be
> > very latency sensitive when compared to writes. Should we consider them
> > separately in the RFC?
> Oops, I somehow ended up leaving your first question unanswered. Sorry.
> 
> I do not think we should consider them separately, as long as there is a
> proper IO tracking infrastructure in place. As you mentioned, reads can
> be very latecy sensitive, but the read case could be treated as an
> special case IO controller/IO tracking subsystem. There certainly are
> optimization opportunities. For example, in the synchronous I/O patch ww
> could mark bios with the iocontext of the current task, because it will
> happen to be originator of that IO. By effectively caching the ownership
> information in the bio we can avoid all the accesses to struct page,
> page_cgroup, etc, and reads would definitively benefit from that. 

FYI, we should also take special care of pages being reclaimed, the free
memory of the cgroup these pages belong to may be really low.
Dm-ioband is doing this.

Thanks,
Hirokazu Takahashi.

