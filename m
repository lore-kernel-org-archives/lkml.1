Return-Path: <linux-kernel-owner+w=401wt.eu-S1757358AbXKFTBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358AbXKFTBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbXKFTBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:01:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34825 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbXKFTBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:01:30 -0500
Subject: Re: writeout stalls in current -git
From: Peter Zijlstra <peterz@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
In-Reply-To: <20071106042527.GT995458@sgi.com>
References: <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
	 <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
	 <20071102204258.GR995458@sgi.com>
	 <64bb37e0711040319l5de285c3xea64474540a51b6e@mail.gmail.com>
	 <20071105014510.GU66820511@sgi.com>
	 <64bb37e0711051027v49869699s9593ea54713b15ff@mail.gmail.com>
	 <20071106042527.GT995458@sgi.com>
Content-Type: text/plain
Date: Tue, 06 Nov 2007 20:01:22 +0100
Message-Id: <1194375682.6289.88.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 15:25 +1100, David Chinner wrote:

> I'm struggling to understand what possible changed in XFS or writeback that
> would lead to stalls like this, esp. as you appear to be removing files when
> the stalls occur. 

Just a crazy idea,..

Could there be a set_page_dirty() that doesn't have
balance_dirty_pages() call near? For example modifying meta data in
unlink?

Such a situation could lead to an excess of dirty pages and the next
call to balance_dirty_pages() would appear to stall, as it would
desperately try to get below the limit again.

