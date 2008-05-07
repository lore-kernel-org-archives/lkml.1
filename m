Return-Path: <linux-kernel-owner+w=401wt.eu-S934021AbYEGWcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021AbYEGWcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbYEGWcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:32:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35072 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbYEGWcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:32:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: sparc64 bootup regression...
Date: Thu, 8 May 2008 00:32:09 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com
References: <20080429.231241.221824292.davem@davemloft.net> <200805080009.46012.rjw@sisk.pl> <20080507152528.8fa6a951.akpm@linux-foundation.org>
In-Reply-To: <20080507152528.8fa6a951.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805080032.09714.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 8 of May 2008, Andrew Morton wrote:
> On Thu, 8 May 2008 00:09:45 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Wednesday, 30 of April 2008, Andrew Morton wrote:
> > > On Tue, 29 Apr 2008 23:12:41 -0700 (PDT) David Miller <davem@davemloft.net> wrote:
> > > 
> > > > 
> > > > This commit causes bootup failures on sparc64:
> > > > 
> > > > commit 86f6dae1377523689bd8468fed2f2dd180fc0560
> > > > Author: Yasunori Goto <y-goto@jp.fujitsu.com>
> > > > Date:   Mon Apr 28 02:13:33 2008 -0700
> > > > 
> > > >     memory hotplug: allocate usemap on the section with pgdat
> > > >     
> > > >     Usemaps are allocated on the section which has pgdat by this.
> > > >     
> > > >     Because usemap size is very small, many other sections usemaps are allocated
> > > >     on only one page.  If a section has usemap, it can't be removed until removing
> > > >     other sections.  This dependency is not desirable for memory removing.
> > > >     
> > > >     Pgdat has similar feature.  When a section has pgdat area, it must be the last
> > > >     section for removing on the node.  So, if section A has pgdat and section B
> > > >     has usemap for section A, Both sections can't be removed due to dependency
> > > >     each other.
> > > >     
> > > >     To solve this issue, this patch collects usemap on same section with pgdat.
> > > >     If other sections doesn't have any dependency, this section will be able to be
> > > >     removed finally.
> > > 
> > > Thanks.  Does a straightforward revert fix it?  If so, we could do that while heads
> > > are being scratched.
> > 
> > Has that been reverted already?
> 
> yes, it has.
> 
> commit 5167464446e527b5a3b5618ba0baff93048bcbbe
> Author: Andrew Morton <akpm@linux-foundation.org>
> Date:   Wed Apr 30 00:55:17 2008 -0700
> 
>     revert "memory hotplug: allocate usemap on the section with pgdat"

OK, thanks.
