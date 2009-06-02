Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbZFBNjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbZFBNjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbZFBNjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:39:03 -0400
Received: from one.firstfloor.org ([213.235.205.2]:32864 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbZFBNjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:39:02 -0400
Date: Tue, 2 Jun 2009 15:46:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, hugh@veritas.com, riel@redhat.com,
       akpm@linux-foundation.org, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       fengguang.wu@intel.com
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090602134610.GO1065@one.firstfloor.org>
References: <20090528134520.GH1065@one.firstfloor.org> <20090601120537.GF5018@wotan.suse.de> <20090601185147.GT1065@one.firstfloor.org> <20090602121031.GC1392@wotan.suse.de> <20090602123450.GF1065@one.firstfloor.org> <20090602123720.GF1392@wotan.suse.de> <20090602125538.GH1065@one.firstfloor.org> <20090602130306.GA6262@wotan.suse.de> <20090602132002.GJ1065@one.firstfloor.org> <20090602131937.GB6262@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602131937.GB6262@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 03:19:37PM +0200, Nick Piggin wrote:
> > I assume that if an application does something with EIO it 
> > can either retry a few times or give up. Both is ok here.
> 
> That's exactly the case where it is not OK, because the
> dirty page was now removed from pagecache, so the subsequent
> fsync is going to succeed and the app will think its dirty
> data has hit disk.

Ok that's a fair point -- that's a hole in my scheme. I don't
know of a good way to fix it though. Do you?

I suspect adding a new errno would break more cases than fixing
them.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
