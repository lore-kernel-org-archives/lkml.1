Return-Path: <linux-kernel-owner+w=401wt.eu-S964857AbXBTN3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964857AbXBTN3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 08:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964885AbXBTN3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 08:29:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964857AbXBTN27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 08:28:59 -0500
Message-ID: <45DAF794.2000209@redhat.com>
Date: Tue, 20 Feb 2007 08:28:52 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] free swap space when (re)activating page
References: <45D63445.5070005@redhat.com> <Pine.LNX.4.64.0702192048150.9934@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0702192048150.9934@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Fri, 16 Feb 2007, Rik van Riel wrote:
> 
>> What do you think?
> 
> Looks good apart from one passage (which just vanished when I tried to 
> reply, please post patches as inline text).
> 
> It was the portion that modifies shrink_active_list. Why operate
> on the pagevec there? The pagevec only contains the leftovers to be 
> released from scanning over the temporary inactive list.

Why?  Because the pages that were not referenced will be
going onto the inactive list and are now a candidate for
swapping out.  I don't see why we would want to reclaim
the swap space for pages that area about to be swapped
out again.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
