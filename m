Return-Path: <linux-kernel-owner+w=401wt.eu-S934286AbYEGWrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934286AbYEGWrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933298AbYEGWq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:46:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55590
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S934249AbYEGWqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:46:24 -0400
Date: Wed, 07 May 2008 15:46:16 -0700 (PDT)
Message-Id: <20080507.154616.132165344.davem@davemloft.net>
To: rjw@sisk.pl
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       y-goto@jp.fujitsu.com
Subject: Re: sparc64 bootup regression...
From: David Miller <davem@davemloft.net>
In-Reply-To: <200805080009.46012.rjw@sisk.pl>
References: <20080429.231241.221824292.davem@davemloft.net>
	<20080429233832.168fb6ee.akpm@linux-foundation.org>
	<200805080009.46012.rjw@sisk.pl>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Thu, 8 May 2008 00:09:45 +0200

> On Wednesday, 30 of April 2008, Andrew Morton wrote:
> > On Tue, 29 Apr 2008 23:12:41 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> > 
> > > 
> > > This commit causes bootup failures on sparc64:
> > > 
> > > commit 86f6dae1377523689bd8468fed2f2dd180fc0560
> > > Author: Yasunori Goto <y-goto@jp.fujitsu.com>
> > > Date:   Mon Apr 28 02:13:33 2008 -0700
> > > 
> > >     memory hotplug: allocate usemap on the section with pgdat
> > >     
> > >     Usemaps are allocated on the section which has pgdat by this.
> > >     
> > >     Because usemap size is very small, many other sections usemaps are allocated
> > >     on only one page.  If a section has usemap, it can't be removed until removing
> > >     other sections.  This dependency is not desirable for memory removing.
> > >     
> > >     Pgdat has similar feature.  When a section has pgdat area, it must be the last
> > >     section for removing on the node.  So, if section A has pgdat and section B
> > >     has usemap for section A, Both sections can't be removed due to dependency
> > >     each other.
> > >     
> > >     To solve this issue, this patch collects usemap on same section with pgdat.
> > >     If other sections doesn't have any dependency, this section will be able to be
> > >     removed finally.
> > 
> > Thanks.  Does a straightforward revert fix it?  If so, we could do that while heads
> > are being scratched.
> 
> Has that been reverted already?

Yes.
