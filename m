Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZIUJRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZIUJRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZIUJRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:17:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068AbZIUJRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:17:51 -0400
Date: Mon, 21 Sep 2009 11:17:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>
Subject: Re: BUG: sleeping function called from invalid context at 
 mm/slub.c:1717
In-Reply-To: <28c262360909160016m19edee02g9215669f854e1026@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0909211114400.17028@wotan.suse.de>
References: <20090915085441.GF23126@kernel.dk>  <alpine.LNX.2.00.0909151202560.17028@wotan.suse.de> <28c262360909160016m19edee02g9215669f854e1026@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, Minchan Kim wrote:

> We have to change description of hid_input_report.
> 
>  * @interrupt: called from atomic?
> I think it lost meaning.

Good point, I will change it, thanks.

> I am worried that interrupt variable is propagated down to sub 
> functions. Is it right on sub functions?

Yes. This variable is not used for chosing correct allocation flags 
anywhere else, it is just carrying the semantics what the HID core should 
do, what callbacks to call, etc. So it's correct.
But you are right that the name and kerneldocs is confusing, and I will 
fix that.

> One more thing, I am concerned about increasing GFP_ATOMIC customers 
> although we can avoid it. Is it called rarely? Could you find a 
> alternative method to overcome this issue?

This is just a temporary buffer for debugging output, it is freed almost 
immediately later in the function, and even if the allocation fails, 
nothing bad happens (just the debugging output is not delivered to the 
debugfs buffer).

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
