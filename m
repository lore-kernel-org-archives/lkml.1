Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbYAGPYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbYAGPYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 10:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYAGPYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 10:24:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbYAGPYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 10:24:38 -0500
Date: Mon, 7 Jan 2008 10:23:53 -0500
From: Rik van Riel <riel@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, lee.schermerhorn@hp.com
Subject: Re: [patch 07/19] split anon & file LRUs for memcontrol code
Message-ID: <20080107102353.382e6c48@bree.surriel.com>
In-Reply-To: <20080107190455.22412330.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080102224144.885671949@redhat.com>
	<20080102224154.309980291@redhat.com>
	<20080107190455.22412330.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 19:04:55 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 02 Jan 2008 17:41:51 -0500
> linux-kernel@vger.kernel.org wrote:
> 
> > Index: linux-2.6.24-rc6-mm1/mm/vmscan.c
> > ===================================================================
> > --- linux-2.6.24-rc6-mm1.orig/mm/vmscan.c	2008-01-02 15:55:55.000000000 -0500
> > +++ linux-2.6.24-rc6-mm1/mm/vmscan.c	2008-01-02 15:56:00.000000000 -0500
> > @@ -1230,13 +1230,13 @@ static unsigned long shrink_zone(int pri
> >  
> >  	get_scan_ratio(zone, sc, percent);
> >  
> 
> I'm happy if this calclation can be following later.
> ==
> if (scan_global_lru(sc)) {
> 	get_scan_ratio(zone, sc, percent);
> } else {
> 	get_scan_ratio_cgroup(sc->cgroup, sc, percent);
> }
> ==
> To do this, 
> mem_cgroup needs to have recent_rotated_file and recent_rolated_anon ?

One possible problem could be that the cgroup can also have
pages reclaimed in global reclaim, not just in local cgroup
reclaims.

That is, these cgroup's pages can also disappear or get
rotated without the cgroup's recent_rotated_file and 
recent_rotated_anon being affected at all.

Still, having the cgroup do the same thing as the global
zones is probably the best approximation.

-- 
All rights reversed.
