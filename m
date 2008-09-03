Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYICVBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYICVBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYICVBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:01:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753548AbYICVBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:01:08 -0400
Message-ID: <48BEFAF9.3030006@linux-foundation.org>
Date: Wed, 03 Sep 2008 16:00:41 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for allocation
 by the reclaimer
References: <1220467452-15794-5-git-send-email-apw@shadowen.org> <1220475206-23684-1-git-send-email-apw@shadowen.org>
In-Reply-To: <1220475206-23684-1-git-send-email-apw@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:

>  
>  #ifndef __GENERATING_BOUNDS_H
> @@ -208,6 +211,9 @@ __PAGEFLAG(SlubDebug, slub_debug)
>   */
>  TESTPAGEFLAG(Writeback, writeback) TESTSCFLAG(Writeback, writeback)
>  __PAGEFLAG(Buddy, buddy)
> +PAGEFLAG(BuddyCapture, buddy_capture)	/* A buddy page, but reserved. */
> +	__SETPAGEFLAG(BuddyCapture, buddy_capture)
> +	__CLEARPAGEFLAG(BuddyCapture, buddy_capture)

Doesnt __PAGEFLAG do what you want without having to explicitly specify
__SET/__CLEAR?


How does page allocator fastpath behavior fare with this pathch?
