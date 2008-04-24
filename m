Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbYDXT14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbYDXT14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYDXT1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:27:48 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:21616 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYDXT1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:27:47 -0400
To: Timur Tabi <timur@freescale.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Calling free_pages on part of the memory returned by get_free_pages?
From: Andi Kleen <andi@firstfloor.org>
References: <480D032E.20204@freescale.com>
Date: Thu, 24 Apr 2008 21:27:19 +0200
In-Reply-To: <480D032E.20204@freescale.com> (Timur Tabi's message of "Mon, 21 Apr 2008 16:12:14 -0500")
Message-ID: <87r6cvxdd4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Apr 2008 19:20:29.0329 (UTC) FILETIME=[41DEB010:01C8A640]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Timur Tabi <timur@freescale.com> writes:

> According to LDD3, if I call get_free_pages() to allocate X bytes, I have to
> free all of those pages with free_pages().  The VM internals are a little bit
> over my head, but I looked at the code and I didn't see why that is a requirement.
>
> For example, let's say I want to allocated 6MB of physically-contiguous memory.
>  If I call x = get_free_pages(11) to get 8MB.  What happens if I then do
> "free_pages(x + 6 * 1024 * 1024, 9)"?
>
> I remember doing this on the 2.4 kernel, and it never gave me any problems.

It is ok, as long as you don't use compound pages (__GFP_COMP) and call
split_page() to fix up the reference counts.

Also you do this to save memory right? The large system hash code does it too
and I used to do it in some 2.4 change with an alloc_pages_exact()
which never made it into 2.6.

If it's reasonably common we should re-add alloc/get_pages_exact() helper to 
make this pattern clear and easier to use.

-Andi
