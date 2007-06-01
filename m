Return-Path: <linux-kernel-owner+w=401wt.eu-S1759979AbXFAHuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759979AbXFAHuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 03:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbXFAHuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 03:50:09 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752AbXFAHuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 03:50:07 -0400
Date: Fri, 1 Jun 2007 00:49:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>, Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 8/8] Per-container pages reclamation
Message-Id: <20070601004922.b03cfc75.akpm@linux-foundation.org>
In-Reply-To: <465FCE59.2070703@openvz.org>
References: <465D9739.8070209@openvz.org>
	<465D9B62.5050507@openvz.org>
	<20070530144737.56456aaf.akpm@linux-foundation.org>
	<465EA4FF.1000904@openvz.org>
	<20070531105842.0728f577.akpm@linux-foundation.org>
	<465FCE59.2070703@openvz.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jun 2007 11:44:25 +0400 Pavel Emelianov <xemul@openvz.org> wrote:

> Andrew Morton wrote:
> > On Thu, 31 May 2007 14:35:43 +0400
> > Pavel Emelianov <xemul@openvz.org> wrote:
> > 
> >>> Would I be correct in guessing that pages which are on the
> >>> per-rss-container lists are also eligible for reclaim off the traditional
> >>> page LRUs?  If so, how does that work?  When a page gets freed off the
> >> Yes. All the pages are accessible from booth - global and per-container
> >> LRU lists and reclamation can be performed from booth.
> >>
> >>> per-zone LRUs does it also get removed from the per-rss_container LRU?  But
> >>> how can this be right?  
> >> I don't get your idea here.
> > 
> > If we have a page which is on the zone LRU with refcount=1 and someone does
> > put_page() on it, we will take that page off the zone LRU and then actually
> > free the page.
> > 
> > I am assuming that your patches change that logic so that we will also
> > remove that page from the per-container LRU at the same time?
> 
> Oh, I see. No that will work another way. Page stays in per-container
> LRU lists as long as it is mapped. When the last process is unmapping
> the page, it it is removed, but stays in global LRU till its refcount
> drops to 0.

ho hum, OK.  This wasn't obvious from the code and it isn't something
I should have learned by emailing you guys!  Please have a think about
preparing an overall decription of the design and implementation of this
rather important kernel change?
