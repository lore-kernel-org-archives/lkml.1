Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbYCFGPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbYCFGPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 01:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYCFGPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 01:15:25 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51240
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbYCFGPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 01:15:24 -0500
Message-ID: <47CF8B31.6040001@qumranet.com>
Date: Thu, 06 Mar 2008 08:12:01 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: akpm@linux-foundation.org, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org
Subject: Re: [kvm-devel] Notifier for Externally Mapped Memory (EMM) V1
References: <Pine.LNX.4.64.0803051600470.7481@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0803051600470.7481@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0rc1 (firebolt.argo.co.il [0.0.0.0]); Thu, 06 Mar 2008 08:12:02 +0200 (IST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
>  
>  /*
> + * Notifier for devices establishing their own references to Linux
> + * kernel pages in addition to the regular mapping via page
> + * table and rmap. The notifier allows the device to drop the mapping
> + * when the VM removes references to pages.
> + */
> +enum emm_operation {
> +	emm_release,		/* Process existing, */
> +	emm_invalidate_start,	/* Before the VM unmaps pages */
> +	emm_invalidate_end,	/* After the VM unmapped pages */
> +	emm_referenced		/* Check if a range was referenced */
> +};
>   

Check and clear


btw, a similar test and clear dirty would be useful as well, no?

> +
> +struct emm_notifier {
> +	int (*callback)(struct emm_notifier *e, struct mm_struct *mm,
> +		enum emm_operation op,
> +		unsigned long start, unsigned long end);
> +	struct emm_notifier *next;
> +};
> +
>   

It is cleaner for the user to specify individual callbacks instead of 
having a switch.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

