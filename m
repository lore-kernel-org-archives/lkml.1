Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbXGCJtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbXGCJtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 05:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756504AbXGCJtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 05:49:14 -0400
Received: from smtp.nokia.com ([131.228.20.173]:39645 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421AbXGCJtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 05:49:13 -0400
Date: Tue, 3 Jul 2007 12:47:02 +0300
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: dedekind@infradead.org, linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] oops and panic message logging to MTD
Message-ID: <20070703094702.GA11992@angel.research.nokia.com>
Reply-To: Jarkko Lavinen <jarkko.lavinen@nokia.com>
References: <1182184301.6074.62.camel@localhost.localdomain> <1182239749.4403.48.camel@sauron> <1182247254.5760.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182247254.5760.17.camel@localhost.localdomain>
X-Operating-System: GNU/Linux angel.research.nokia.com
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 03 Jul 2007 09:48:40.0085 (UTC) FILETIME=[55B18450:01C7BD57]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 11:00:54AM +0100, Richard Purdie wrote:
> Its not a case of formatting the whole partition. The whole point of
> this code is the following use case:
> 
> 1. Device crashes
> 2. Device reboots
> 3. mtdoops partition has a log of why it crashed

The oops logger uses oops_in_progress variable to detect the begin and the 
end of an oops.  The end is detected when the first non-oops line comes and
oops_in_progress is false.

This works if the kernel is still running after the oops and gemerates some 
non-oops messages.  But if there is no non-oops line following an oops, no
flushing will occur and there won't be a log on flash.

Jarkko Lavinen
