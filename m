Return-Path: <linux-kernel-owner+w=401wt.eu-S932982AbYEGW01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982AbYEGW01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbYEGW0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:26:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757417AbYEGW0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:26:06 -0400
Date: Wed, 7 May 2008 15:25:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com
Subject: Re: sparc64 bootup regression...
Message-Id: <20080507152528.8fa6a951.akpm@linux-foundation.org>
In-Reply-To: <200805080009.46012.rjw@sisk.pl>
References: <20080429.231241.221824292.davem@davemloft.net>
	<20080429233832.168fb6ee.akpm@linux-foundation.org>
	<200805080009.46012.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 May 2008 00:09:45 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

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

yes, it has.

commit 5167464446e527b5a3b5618ba0baff93048bcbbe
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Wed Apr 30 00:55:17 2008 -0700

    revert "memory hotplug: allocate usemap on the section with pgdat"

