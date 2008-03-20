Return-Path: <linux-kernel-owner+w=401wt.eu-S1759165AbYCTWST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759165AbYCTWST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbYCTWSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:18:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39077 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757012AbYCTWSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:18:10 -0400
Date: Thu, 20 Mar 2008 18:17:57 -0400
From: Rik van Riel <riel@redhat.com>
To: Brian Harring <ferringb@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fsync/MAP_SHARED slowdown
Message-ID: <20080320181757.737af9b4@cuia.boston.redhat.com>
In-Reply-To: <20080320201216.GA4910@seldon.hsd1.ca.comcast.net>
References: <20080320201216.GA4910@seldon.hsd1.ca.comcast.net>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 13:12:16 -0700
Brian Harring <ferringb@gmail.com> wrote:

> Back in 09/2006, rev d08b3851da41d0ee60851f2c75b118e1f7a5fc89 
> (discussion at http://lkml.org/lkml/2006/6/19/245) was commited with 
> the purpose enabling tracking of shared dirty pages.
> 
> Still trying to identify exactly why, but that specific rev results in 
> a ~3x slowdown in fsync speed for an app of ours- an isolated test 
> case demonstrating it is attached.

The kernel now includes an implicit msync for each fsync.

In short, before the change an fsync would not find all the dirty pages
of the file, because some of the dirty bits might be "hiding" in the
page tables, while the current kernel actually finds those dirty bits
and writes all dirty data to disk.

Would you rather have the fast fsync, or the one that actually writes
all the dirty data to disk? :)

-- 
All Rights Reversed
