Return-Path: <linux-kernel-owner+w=401wt.eu-S1161148AbXCAXKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161148AbXCAXKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 18:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161217AbXCAXKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 18:10:31 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:37772 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161148AbXCAXKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 18:10:30 -0500
Date: Thu, 1 Mar 2007 15:10:03 -0800
From: Bill Irwin <bill.irwin@oracle.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, arjan@linux.intel.com
Subject: Re: [PATCH (updated)] timer: Run calc_load halfway through each round_jiffies second
Message-ID: <20070301231003.GD10643@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Simon Arlott <simon@fire.lp0.eu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org, arjan@linux.intel.com
References: <45E0577C.9020409@simon.arlott.org.uk> <45E698DF.4010006@simon.arlott.org.uk> <45E720E8.1010809@simon.arlott.org.uk> <45E75911.3070907@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E75911.3070907@simon.arlott.org.uk>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 10:52:01PM +0000, Simon Arlott wrote:
> Whenever jiffies is started at a multiple of 5*HZ or wraps, calc_load is 
> run exactly on the second which is when tasks using round_jiffies will 
> be scheduled to run. This has a bad effect on the load average, making 
> it tend towards 1.00 if a task happens to run every time the load is 
> being calculated.
> This changes calc_load so that it updates load half a second after any 
> tasks scheduled using round_jiffies.
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>

Well, it doesn't reintroduce the for_each_task() (not that it's present
in similar form) loop in count_active_tasks(), so it doesn't bother me.
You seem to have merely changed some offsets, which resolves the
round_jiffies() clash. It's easy to envision similar degenerate cases,
though I'm not sure we care enough to drop in a PRNG to handle them.


== wli
