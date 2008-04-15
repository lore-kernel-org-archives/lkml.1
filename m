Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbYDOIZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbYDOIZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754328AbYDOIZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:25:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49389 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbYDOIZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:25:08 -0400
Subject: Re: [DOC PATCH] semaphore documentation
From: David Woodhouse <dwmw2@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>
In-Reply-To: <20080412141250.GK11962@parisc-linux.org>
References: <20080410143403.c03757e5.akpm@linux-foundation.org>
	 <20080410220816.GY11962@parisc-linux.org>
	 <20080410151907.91f11c74.akpm@linux-foundation.org>
	 <20080411192153.GH11962@parisc-linux.org>
	 <20080411132754.b1c1fd8f.randy.dunlap@oracle.com>
	 <20080411220911.3e7ab3e4.akpm@linux-foundation.org>
	 <20080412141250.GK11962@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 09:24:29 +0100
Message-Id: <1208247869.2648.27.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-12 at 08:12 -0600, Matthew Wilcox wrote:
> As I wrote in one of the comments, we have places in the kernel which
> know that even though they're in a non-sleeping context, there is at
> least one more token left in the semaphore.  One place this bit me was
> in start_kernel().  We disable interrupts and then call lock_kernel()
> which calls down().  Since we're in start_kernel(), we know there's
> nothing else running and this is perfectly safe.  But a might_sleep()
> would warn bogusly.

I would have thought they'd use down_trylock() in that case.

-- 
dwmw2

