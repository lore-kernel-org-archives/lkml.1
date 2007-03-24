Return-Path: <linux-kernel-owner+w=401wt.eu-S1751738AbXCXBkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbXCXBkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 21:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbXCXBkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 21:40:35 -0400
Received: from kanga.kvack.org ([66.96.29.28]:39088 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738AbXCXBke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 21:40:34 -0400
Date: Fri, 23 Mar 2007 21:40:24 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Christoph Hellwig <hch@infradead.org>, Ken Chen <kenchen@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] cache pipe buf page address for non-highmem arch
Message-ID: <20070324014024.GL17334@kvack.org>
References: <b040c32a0703221751x54417524l5237742f345eeda9@mail.gmail.com> <20070323101452.GA15144@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323101452.GA15144@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 10:14:52AM +0000, Christoph Hellwig wrote:
> I think you're fixing the symptom here and not the cause.  If calculating
> the virtual address of a page is so expensive on your setup it should
> define WANT_PAGE_VIRTUAL and we should always cache the virtual address
> in struct page.  There's a lot more code, epecially in filesystems that's
> rather upset about a slow page_address.

Andi shot that down when I brought it up a while ago, as it does show 
up in profiles for networking and other code paths.  His argument is that 
the loss of memory is excessive.  Personally, I think the benefits of a 
64 byte struct page on x86-64 outweigh the memory loss, as it means page 
index to address translations are a simple shift.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
