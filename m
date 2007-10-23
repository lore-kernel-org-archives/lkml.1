Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbXJWONk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbXJWONk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXJWONc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:13:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58337 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbXJWONb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:13:31 -0400
Date: Tue, 23 Oct 2007 10:10:53 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Mahoney <jeffm@suse.com>, reiserfs-dev@namesys.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] reiserfs: don't drop PG_dirty when releasing
 sub-page-sized dirty file
Message-ID: <20071023101053.638fe207@think.oraclecorp.com>
In-Reply-To: <393140585.27414@ustc.edu.cn>
References: <200710220822.52370.maximlevitsky@gmail.com>
	<200710221258.11384.maximlevitsky@gmail.com>
	<393051953.24752@ustc.edu.cn>
	<200710221421.21439.maximlevitsky@gmail.com>
	<393126119.26275@ustc.edu.cn>
	<1193134027.7406.1.camel@twins>
	<393140585.27414@ustc.edu.cn>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 19:56:20 +0800
Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

> On Tue, Oct 23, 2007 at 12:07:07PM +0200, Peter Zijlstra wrote:
> > [ adding reiserfs devs to the CC ]
> 
> Thank you.
> 
> This fix is kind of crude - even when it fixed Maxim's problem, and
> survived my stress testing of a lot of patching and kernel compiling.
> I'd be glad to see better solutions.

This should be safe, reiserfs has the buffer heads themselves clean and
the page should get cleaned eventually.  The cancel_dirty_page call was
just an optimization to be VM friendly.

-chris
