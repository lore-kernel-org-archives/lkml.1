Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbYAOUKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbYAOUKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbYAOUKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:10:06 -0500
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:49115 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbYAOUKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:10:05 -0500
Date: Tue, 15 Jan 2008 20:10:54 +0000
From: Andy Whitcroft <andyw@uk.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Make checkpatch.pl's quiet option not print the summary on no errors
Message-ID: <20080115201054.GC21511@shadowen.org>
References: <477C3252.1080001@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <477C3252.1080001@linux.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 01:54:42AM +0100, Arjan van de Ven wrote:
> Subject: Make checkpatch.pl's quiet option not print the summary on no 
> errors
> From: Arjan van de Ven <arjan@linux.intel.com>
> CC: apw@uk.ibm.com
> 
> Right now, in quiet mode, checkpatch.pl still prints a summary line even
> if the patch is 100% clean. IMO, "quiet mode" should mean "no output if 
> clean",
> the patch below makes that so. (This also makes the quilt integration
> on my system work nicer :)
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

While looking to integrate this I discovered that the current default
was a desired feature requested by Ingo.  So I guess we need to come up
with a combination of options which give us both.

Currently we have --[no-]summary meaning suppress/add a summary, and
--quiet meaning suppress output but which does not suppress the summary.

We have a few options:

1) allow doubling of -q to make the summary subject to -q,
2) allow doubling of --summary to mean "override -q", --summary becoming
   subject to -q,
3) add a new option --force-summary which always produces a summary,
   --summary becoming subject to -q, and
4) add a new option --summary-on-fail which is subject to -q.

I feel the last of these is the most obvious option, and carries
no modification to current semantics.

Thoughts?

-apw
