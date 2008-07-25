Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbYGYJ0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbYGYJ0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYGYJ02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:26:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbYGYJ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:26:27 -0400
Date: Fri, 25 Jul 2008 02:25:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrea Righi <righi.andrea@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PAGE_ALIGN() compile breakage
Message-Id: <20080725022547.a05ea755.akpm@linux-foundation.org>
In-Reply-To: <20080725091455.GD19310@cs181140183.pp.htv.fi>
References: <20080725083943.GC19310@cs181140183.pp.htv.fi>
	<20080725015537.564e3397.akpm@linux-foundation.org>
	<20080725091455.GD19310@cs181140183.pp.htv.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 12:14:55 +0300 Adrian Bunk <bunk@kernel.org> wrote:

> Ideally, all headers should be self-contained. IOW, they should #include 
> everything they use.

Yup.  And the core reason for our headers mess is that the headers do
too much stuff, and cnosequently demand a large dependency trail.

> But TASK_UNMAPPED_BASE in asm/processor.h on some architectures uses 
> PAGE_ALIGN() that got moved from asm/page.h to linux/mm.h .

Probably mm.h should be split up - put the simple things (usually
declarations) into one "early" header file and leave the more
heavyweight things (usually implementations) in mm.h.
