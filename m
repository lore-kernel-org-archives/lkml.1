Return-Path: <linux-kernel-owner+w=401wt.eu-S1423072AbXBIAkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423072AbXBIAkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 19:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423156AbXBIAkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 19:40:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35197 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423072AbXBIAkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 19:40:00 -0500
Date: Fri, 9 Feb 2007 09:39:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, ak@suse.de,
       y-goto@jp.fujitsu.com
Subject: Re: Fw: [BUG][PATCH] fix mempolcy's check on a system with
 memory-less-node take3
Message-Id: <20070209093932.16f59194.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0702081125160.11045@schroedinger.engr.sgi.com>
References: <20070208173608.c31c2e13.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0702081125160.11045@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007 11:28:30 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:
> > @@ -193,9 +197,11 @@
> >  		break;
> >  	case MPOL_BIND:
> >  		policy->v.zonelist = bind_zonelist(nodes);
> > -		if (policy->v.zonelist == NULL) {
> > +		if (IS_ERR(policy->v.zonelist)) {
> > +			void *val = policy->v.zonelist;
> > +			policy->v.zonelist = NULL;
> 
> void *? Ahh. It takes the error code.
> 
> Looks good. But if we are really going down this road of memory-less 
> nodes we may want to audit the kernel for other issues.
> 
> Could you run a series of tests on that machine?
> 
Yes. The program which caused trouble works fine.
I used 'numademo' command in numactl package.
It works fine (reports -EINVAL) with this patch now.

I uses this a system with an empty-node for 5 months.
reported 2 bugs.
- oom-kill's memory less node detection logic.
- mempolicy's NULL access(this)

It works fine in general.
(old RHEL4/linux-2.6.9 kernel doesn't boot on this system.)

-Kame









