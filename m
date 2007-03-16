Return-Path: <linux-kernel-owner+w=401wt.eu-S933603AbXCPLmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbXCPLmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933602AbXCPLmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:42:08 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42274 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933603AbXCPLmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:42:06 -0400
Date: Fri, 16 Mar 2007 03:41:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Keir Fraser <keir@xensource.com>
Cc: Ingo Molnar <mingo@elte.hu>, Keir Fraser <Keir.Fraser@xensource.com>,
       <virtualization@lists.osdl.org>, <xen-devel@lists.xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [patch 21/26] Xen-paravirt_ops: Use the hvc
 console infrastructure for Xen console
Message-Id: <20070316034123.9de92632.akpm@linux-foundation.org>
In-Reply-To: <C2202295.BA49%keir@xensource.com>
References: <20070316095851.GB301@elte.hu>
	<C2202295.BA49%keir@xensource.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 10:31:49 +0000 Keir Fraser <keir@xensource.com> wrote:

> On 16/3/07 09:58, "Ingo Molnar" <mingo@elte.hu> wrote:
> 
> >> These mb()'s are pretty standard for lock-free producer/consumer
> >> rings. Write descriptor /then/ write the updated producer. Read the
> >> producer /then/ read any descriptors revealed by this new producer
> >> value.
> > 
> > then use rmb()/wmb(). Rarely does a ring protocol truly need mb().
> 
> It's needed for writing data /after/ reading the consumer index that shows
> you have space to write. Looking through xenbus_comms.c I think all the
> barriers are correct except there is a spurious extra mb() in xb_read(),
> where there is a later rmb() which is sufficient by itself. All the others
> have a purpose.
> 

If Ingo couldn't work this out from reading the code then nobody else can,
and we have a maintainability problem which can only be solved with
adequate commenting.
