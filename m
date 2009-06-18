Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbZFRVRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbZFRVRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 17:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbZFRVRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 17:17:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38090 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbZFRVRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 17:17:04 -0400
Message-ID: <4A3AAECE.3050807@linux.vnet.ibm.com>
Date: Thu, 18 Jun 2009 14:17:02 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter tools: Handle lost events
References: <new-submission> <tip-9d91a6f7a489eb914c16b82d927f9d81d629c259@git.kernel.org>
In-Reply-To: <tip-9d91a6f7a489eb914c16b82d927f9d81d629c259@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tip-bot for Peter Zijlstra wrote:
> Commit-ID:  9d91a6f7a489eb914c16b82d927f9d81d629c259
> Gitweb:     http://git.kernel.org/tip/9d91a6f7a489eb914c16b82d927f9d81d629c259
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Thu, 18 Jun 2009 11:40:28 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 18 Jun 2009 14:46:11 +0200
> 
> perf_counter tools: Handle lost events
> 
> Make use of the new ->data_tail mechanism to tell kernel-space
> about user-space draining the data stream. Emit lost events
> (and display them) if they happen.
[snip]
> @@ -109,7 +120,7 @@ static void mmap_read(struct mmap_data *md)
>  	 * In either case, truncate and restart at head.
>  	 */
>  	diff = head - old;
> -	if (diff > md->mask / 2 || diff < 0) {
> +	if (diff < 0) {
>  		struct timeval iv;
>  		unsigned long msecs;
> 
[snip]

Hi Peter,

Very nice change.  One thing missing though on the above is an update to the 
comment which precedes snippet, which currently reads:

	/*
	 * If we're further behind than half the buffer, there's a chance
	 * the writer will bite our tail and mess up the samples under us.
	 *
	 * If we somehow ended up ahead of the head, we got messed up.
	 *
	 * In either case, truncate and restart at head.
	 */

The "further behind than half the buffer" no longer pertains.  Maybe:


	/*
	 * If we've gotten behind, truncate and restart at head.
	 */

Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
cjashfor@us.ibm.com

