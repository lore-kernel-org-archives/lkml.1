Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbYHGEip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbYHGEip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 00:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYHGEiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 00:38:18 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:38851 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYHGEiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 00:38:18 -0400
Subject: Re: RFC: I/O bandwidth controller
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ryo Tsuruta <ryov@valinux.co.jp>, xen-devel@lists.xensource.com,
       uchida@ap.jp.nec.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@sourceware.org,
       virtualization@lists.linux-foundation.org, ngupta@google.com,
       righi.andrea@gmail.com
In-Reply-To: <1218037688.10907.85.camel@nimitz>
References: <20080804.175126.193692178.ryov@valinux.co.jp>
	 <1217870433.20260.101.camel@nimitz>
	 <1217985189.3154.57.camel@sebastian.kern.oss.ntt.co.jp>
	 <20080806.151824.104049463.ryov@valinux.co.jp>
	 <1218004892.3950.12.camel@sebastian.kern.oss.ntt.co.jp>
	 <1218037688.10907.85.camel@nimitz>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Thu, 07 Aug 2008 13:38:15 +0900
Message-Id: <1218083895.3803.202.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 08:48 -0700, Dave Hansen wrote:
> On Wed, 2008-08-06 at 15:41 +0900, Fernando Luis Vázquez Cao wrote:
> > > I agree with your plan.
> > > We keep bio-cgroup improving and porting to the latest kernel.
> > Having more users of bio-cgroup would probably help to get it merged, so
> > we'll certainly send patches as soon as we get our cfq prototype in
> > shape.
> 
> I'm confused.  Are these two of the competing controllers?  Or are the
> complementary in some way?
Sorry, I did not explain myself correctly. I was not referring to a new
IO _controller_, I was just trying to say that the traditional IO
_schedulers_ already present in the mainstream kernel would benefit from
proper IO tracking too. As an example, the current implementation of CFQ
assumes that all IO is generated in the IO context of the current task,
which in only true in the synchronous path. This renders CFQ almost
unusable for controlling of asynchronous and buffered IO. Of course CFQ
is not to blame here, since it has no way to tell who the real
originator of the IO was (CFQ just sees IO requests coming from pdflush
and other kernel threads).

However, once we have a working IO tracking infrastructure in place, the
existing IO _schedulers_ could be modified so that they use it to
determine the real owner/originator of asynchronous and buffered IO.
This can be done without turning IO schedulers into IO resource
controllers. If we can demonstrate that a IO tracking infrastructure
would also be beneficial outside the cgroups arena, it should be easier
to get it merged.

