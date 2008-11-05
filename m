Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYKEDeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYKEDeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 22:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754307AbYKEDd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 22:33:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:41185 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbYKEDd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 22:33:56 -0500
Message-ID: <491113FF.9070007@kernel.org>
Date: Wed, 05 Nov 2008 12:33:19 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Add round_jiffies_up and related routines
References: <Pine.LNX.4.44L0.0811041111020.3614-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0811041111020.3614-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Nov 2008 03:33:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> This patch (as1158) adds round_jiffies_up() and friends.  These
> routines work like the analogous round_jiffies() functions, except
> that they will never round down.
> 
> The new routines will be useful for timeouts where we don't care
> exactly when the timer expires, provided it doesn't expire too soon.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Heh... I have exactly the same patches but mines were named
round_up_jiffies().

> +	unsigned long j0 = jiffies;
> +
> +	barrier();	/* Prevent the compiler from aliasing j0 and jiffies */
> +	return round_jiffies_common(j + j0, cpu, false) - j0;

jiffies is volatile.  No need for explicit barrier, but this part is
necessary for correct operation as if jiffies go up by two the
calculation will wrap and the returned value will be very large.  I
think this fix deserves a separate patch and proper explanation.

Thanks.

-- 
tejun
