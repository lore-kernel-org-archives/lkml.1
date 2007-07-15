Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbXGOUCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbXGOUCv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 16:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931AbXGOUAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 16:00:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55844 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756886AbXGOUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 16:00:47 -0400
Date: Sun, 15 Jul 2007 12:59:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zach Brown <zach.brown@oracle.com>, cmm@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [EXT4 set 5][PATCH 1/1] expand inode i_extra_isize to support
 features in larger inode
Message-Id: <20070715125921.87574a3a.akpm@linux-foundation.org>
In-Reply-To: <1184527263.5284.110.camel@lappy>
References: <1183275482.4010.133.camel@localhost.localdomain>
	<20070710163247.5c8bfa3f.akpm@linux-foundation.org>
	<20070713020529.1486491f.akpm@linux-foundation.org>
	<1184333621.20032.85.camel@twins>
	<20070713121259.20066d5b.akpm@linux-foundation.org>
	<20070713214746.GH23255@mami.zabbo.net>
	<1184504543.5284.96.camel@lappy>
	<20070715111109.a2775ae4.akpm@linux-foundation.org>
	<1184527263.5284.110.camel@lappy>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2007 21:21:03 +0200 Peter Zijlstra <peterz@infradead.org> wrote:

> Shows the current stacktrace where we violate the previously established
> locking order.

yup, but the lock_page() which we did inside truncate_mutex was a 
lock_page() against a different address_space: the blockdev mapping.

So this is OK - we'll never take truncate_mutex against the blockdev
mapping (it doesn't have one, for a start ;))

This is similar to the quite common case where we take inode A's
i_mutex inside inode B's i_mutex, which needs special lockdep annotations.

I think.  I haven't looked into this in detail.
