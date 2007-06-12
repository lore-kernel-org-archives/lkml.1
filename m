Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbXFLSmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbXFLSmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756792AbXFLSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:41:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722AbXFLSly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:41:54 -0400
Message-ID: <466EE818.4050306@redhat.com>
Date: Tue, 12 Jun 2007 14:38:16 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: eranian@hpl.hp.com
CC: oprofile-list@lists.sourceforge.net, wcohen@redhat.com, ak@suse.de,
       perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
       levon@movementarian.org
Subject: Re: OProfile issues
References: <20070612150246.GJ32163@frankl.hpl.hp.com>
In-Reply-To: <20070612150246.GJ32163@frankl.hpl.hp.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2007 11:02 AM, Stephane Eranian wrote:
>  * allocate_msrs() allocates two tables per CPU. One for the
>    counters, the other for the eventsel registers. But then
>    nmi_setup() copies the cpu_msrs[0] into cpu_msrs[] of all
>    other cpus. This operation overrides the cpu_msrs[].counters
>    and cpu_msrs[].controls pointers for all CPUs but CPU0.
>    But free_msrs() will free the same tables multiple times. This
>    causes a kernel dump when you enable certain kernel debugging
>    features. The fix is to copy the content of the counters and
>    controls array, not the pointers.
> 

How old is the kernel you are looking at?

http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=0939c17c7bcf1c838bea4445b80a6966809a438f

...fixed this over 10 days ago.
