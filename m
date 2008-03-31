Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYCaHZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYCaHZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 03:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYCaHZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 03:25:19 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:8596 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbYCaHZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 03:25:18 -0400
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       arjan@linux.intel.com, thomas@tungstengraphics.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 31 Mar 2008 09:25:12 +0200
In-Reply-To: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com>
Message-ID: <87myof8ief.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 31 Mar 2008 07:18:35.0638 (UTC) FILETIME=[6EFBF160:01C892FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie <airlied@redhat.com> writes:
>  
> +#define CPA_FLUSHTLB 1
> +#define CPA_ARRAY 2

I don't think CPA_ARRAY should be a separate case. Rather single
page flushing should be an array with only a single entry. pageattr
is already very complex, no need to make add more special cases.
> +
> +		/*
> +		 * Only flush present addresses:
> +		 */
> +		if (pte && (pte_val(*pte) & _PAGE_PRESENT))
> +			clflush_cache_range((void *) *addr, PAGE_SIZE);

Also it is doubtful clflush really makes sense on a large array. Just
doing wbinvd might be faster then. Or perhaps better supporting Self-Snoop
should be revisited, that would at least eliminate it on most Intel 
CPUs.

-Andi
