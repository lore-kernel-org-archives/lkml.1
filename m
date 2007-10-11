Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbXJKIAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbXJKIAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 04:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXJKIAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 04:00:34 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1060 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843AbXJKIAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 04:00:32 -0400
Date: Thu, 11 Oct 2007 08:59:58 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][try 2] architectural pstate driver for powernow-k8
Message-ID: <20071011075958.GK1130@shadowen.org>
References: <200710091446.38432.mark.langsdorf@amd.com> <p73fy0k3ve8.fsf@bingen.suse.de> <200710091543.21350.mark.langsdorf@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200710091543.21350.mark.langsdorf@amd.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 03:43:20PM -0500, Mark Langsdorf wrote:
> On Tuesday 09 October 2007 15:06, Andi Kleen wrote:
> > "Mark Langsdorf" <mark.langsdorf@amd.com> writes:
> > 
> > > This patch should apply cleanly to the 2.6.22.6 kernel.
> > 
> > Isn't that a little old? The earliest this could be merged
> > is the upcomming 2.6.24 tree. Best you submit it against .23
> > or better -mm.
> 
> Good point.
> 
> This patch should apply cleanly to the 2.6.23-rc8-mm2 kernel.  It changes 
> the powernow-k8 driver code that deals with 3rd generation Opteron, Phenom,
> and later processors to match the architectual pstate driver described
> in the AMD64 Architecture Programmer's Manual Volume 2 Chapter 18.  The
> initial implementation of the hardware pstate driver for PowerNow!
> used some processor-version specific features, and would not be
> maintainable in the long term as the processor features changed.
> This architectural driver should work on all future AMD processors.
> 
> -Mark Langsdorf
> Operating System Resarch Center
> AMD
> 
> Signed-off-by <mark.langsdorf@amd.com>
> Acked-by <andreas.herrmann3@amd.com>
[...]
>  	/* get fid did for hardware pstate transition */
>  	pstate = index & HW_PSTATE_MASK;
> -	if (pstate > MAX_HW_PSTATE)
> +	if (pstate > data->max_hw_pstate);
>  		return 0;

checkpatch picked up this dodgy if.  I suspect that the ';' is wrong
from the context.

> -	fid = (index & HW_FID_INDEX_MASK) >> HW_FID_INDEX_SHIFT;
> -	did = (index & HW_DID_INDEX_MASK) >> HW_DID_INDEX_SHIFT;
> -	freqs.old = find_khz_freq_from_fiddid(data->currfid, data->currdid);
> -	freqs.new = find_khz_freq_from_fiddid(fid, did);
> +	freqs.old = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
> +	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);

-apw
