Return-Path: <linux-kernel-owner+w=401wt.eu-S1030235AbXBTQhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030235AbXBTQhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030218AbXBTQhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:37:54 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55915 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030241AbXBTQhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:37:52 -0500
Date: Tue, 20 Feb 2007 08:37:52 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Rik van Riel <riel@redhat.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] free swap space when (re)activating page
In-Reply-To: <45DAF794.2000209@redhat.com>
Message-ID: <Pine.LNX.4.64.0702200833460.13913@schroedinger.engr.sgi.com>
References: <45D63445.5070005@redhat.com> <Pine.LNX.4.64.0702192048150.9934@schroedinger.engr.sgi.com>
 <45DAF794.2000209@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007, Rik van Riel wrote:

> > It was the portion that modifies shrink_active_list. Why operate
> > on the pagevec there? The pagevec only contains the leftovers to be released
> > from scanning over the temporary inactive list.
> 
> Why?  Because the pages that were not referenced will be
> going onto the inactive list and are now a candidate for
> swapping out.  I don't see why we would want to reclaim
> the swap space for pages that area about to be swapped
> out again.

Sounds sane. Then drop that piece. Again, you were only operating on the 
pages left over in the pagevec after the move of the pages to the 
inactive list. If you really wanted to do something there then the 
processing should have covered all pages that go to the inactive list.
