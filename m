Return-Path: <linux-kernel-owner+w=401wt.eu-S1753042AbXGBHFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbXGBHFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 03:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXGBHFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 03:05:24 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:8127 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbXGBHFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 03:05:21 -0400
Subject: Re: [patch 5/5] Optimize page_mkclean_one
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <1183296468.5180.10.camel@lappy>
References: <20070629135530.912094590@de.ibm.com>
	 <20070629141528.511942868@de.ibm.com>
	 <Pine.LNX.4.64.0706301448450.13752@blonde.wat.veritas.com>
	 <1183274153.15924.6.camel@localhost>
	 <Pine.LNX.4.64.0707010926130.11148@blonde.wat.veritas.com>
	 <1183296468.5180.10.camel@lappy>
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 02 Jul 2007 09:07:26 +0200
Message-Id: <1183360046.12198.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-01 at 15:27 +0200, Peter Zijlstra wrote:
> > But I could easily be overlooking something: Peter will recall.
> 
> /me tries to get his brain up to speed after the OLS closing party :-)

Oh-oh, the Black Thorn party :-)

> I did both pte_dirty and pte_write because I was extra careful. One
> _should_ imply the other, but since we'll be clearing both, I thought it
> prudent to also check both.

Just ran a little experiment: I've added a simple WARN_ON(ret == 0) to
page_mkclean after the page_test_dirty() check to see if there are cases
where the page is dirty and all ptes are read-only. A little stress run
including massive swap did not print a single warning.

> I will have to think on this a little more, but I'm currently of the
> opinion that the optimisation is not correct. But I'll have a thorough
> look at s390 again when I get home.

I think the patch is correct, although I beginning to doubt that is has
any effect.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


