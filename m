Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbYAJChm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbYAJChm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYAJChf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:37:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbYAJChe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:37:34 -0500
Date: Wed, 9 Jan 2008 21:37:21 -0500
From: Rik van Riel <riel@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080109213721.2ef2e5f3@bree.surriel.com>
In-Reply-To: <20080110112849.d54721ac.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080108205939.323955454@redhat.com>
	<20080108210002.638347207@redhat.com>
	<20080110112849.d54721ac.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 11:28:49 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Hmm, it seems..
> 
> When a program copies large amount of files, recent_rotated_file increases
> rapidly and 
> 
>     rotate_sum
>     ----------
> recent_rotated_anon
> 
> will be very big.
> 
> And %ap will be big regardless of vm_swappiness  if it's not 0.
> 
> I think # of recent_successful_pageout(anon/file) should be took into account...
> 
> I'm sorry if I miss something.

You are right.  I wonder if this, again, is a case of myself or
Lee forward porting old code.  I remember having (had) a very
different version of get_scan_ratio() at some point in the past,
but I cannot remember if we discarded this version for that other
version, or the other way around :(

Lee, would you by any chance still have some alternative versions
of get_scan_ratio() around?  I'm searching through my systems, but
have not found it yet...

-- 
All rights reversed.
