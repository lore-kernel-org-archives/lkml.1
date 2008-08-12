Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbYHLFfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbYHLFfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 01:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYHLFf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 01:35:27 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:41059 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYHLFfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 01:35:25 -0400
Subject: Re: RFC: I/O bandwidth controller
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: balbir@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
       uchida@ap.jp.nec.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@sourceware.org, dave@linux.vnet.ibm.com,
       ngupta@google.com, righi.andrea@gmail.com
In-Reply-To: <20080808.203944.29203232.taka@valinux.co.jp>
References: <1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <4899D464.1070506@linux.vnet.ibm.com>
	 <1218078075.3803.149.camel@sebastian.kern.oss.ntt.co.jp>
	 <20080808.203944.29203232.taka@valinux.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Tue, 12 Aug 2008 14:35:23 +0900
Message-Id: <1218519323.3964.0.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-08 at 20:39 +0900, Hirokazu Takahashi wrote:
> Hi,
> 
> > > Would you like to split up IO into read and write IO. We know that read can be
> > > very latency sensitive when compared to writes. Should we consider them
> > > separately in the RFC?
> > Oops, I somehow ended up leaving your first question unanswered. Sorry.
> > 
> > I do not think we should consider them separately, as long as there is a
> > proper IO tracking infrastructure in place. As you mentioned, reads can
> > be very latecy sensitive, but the read case could be treated as an
> > special case IO controller/IO tracking subsystem. There certainly are
> > optimization opportunities. For example, in the synchronous I/O patch ww
> > could mark bios with the iocontext of the current task, because it will
> > happen to be originator of that IO. By effectively caching the ownership
> > information in the bio we can avoid all the accesses to struct page,
> > page_cgroup, etc, and reads would definitively benefit from that. 
> 
> FYI, we should also take special care of pages being reclaimed, the free
> memory of the cgroup these pages belong to may be really low.
> Dm-ioband is doing this.
Thank you for the heads-up.

- Fernando

