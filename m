Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbYFIC62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbYFIC62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 22:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbYFIC6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 22:58:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197AbYFIC6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 22:58:20 -0400
Date: Sun, 8 Jun 2008 22:58:00 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
Message-ID: <20080608225800.17d2e29b@bree.surriel.com>
In-Reply-To: <20080608165434.67c87e5c.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.291472052@redhat.com>
	<20080606180506.081f686a.akpm@linux-foundation.org>
	<20080608163413.08d46427@bree.surriel.com>
	<20080608135704.a4b0dbe1.akpm@linux-foundation.org>
	<20080608173244.0ac4ad9b@bree.surriel.com>
	<20080608162208.a2683a6c.akpm@linux-foundation.org>
	<20080608193420.2a9cc030@bree.surriel.com>
	<20080608165434.67c87e5c.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008 16:54:34 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> ho hum.  Can you remind us what problems this patchset actually
> addresses?  Preferably in order of seriousness?

Here are some other problems that my patch series can easily fix,
because file cache and anon/swap backed pages live on separate
LRUs:

http://feedblog.org/2007/09/29/using-o_direct-on-linux-and-innodb-to-fix-swap-insanity/

http://blogs.smugmug.com/don/2008/05/01/mysql-and-the-linux-swap-problem/

I do not know for sure whether the patch set does fix it yet for
everyone, or whether it needs some more tuning first, but it is
fairly easily fixable by tweaking the relative pressure on both
sets of LRU lists.

No tricks of skipping over one type of pages while scanning, or
treating the referenced bits differently when the moon is in some
particular phase required - one set of lists for each type of
pages, and variable pressure between the two.

-- 
All rights reversed.
