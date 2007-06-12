Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXFLSml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXFLSml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbXFLSl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:41:56 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:44886 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526AbXFLSlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:41:55 -0400
Date: Tue, 12 Jun 2007 11:37:47 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: oprofile-list@lists.sourceforge.net, wcohen@redhat.com, ak@suse.de,
       perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
       levon@movementarian.org
Subject: Re: OProfile issues
Message-ID: <20070612183747.GF3457@sequoia.sous-sol.org>
References: <20070612150246.GJ32163@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612150246.GJ32163@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephane Eranian (eranian@hpl.hp.com) wrote:
>  * allocate_msrs() allocates two tables per CPU. One for the
>    counters, the other for the eventsel registers. But then
>    nmi_setup() copies the cpu_msrs[0] into cpu_msrs[] of all
>    other cpus. This operation overrides the cpu_msrs[].counters
>    and cpu_msrs[].controls pointers for all CPUs but CPU0.
>    But free_msrs() will free the same tables multiple times. This
>    causes a kernel dump when you enable certain kernel debugging
>    features. The fix is to copy the content of the counters and
>    controls array, not the pointers.

This is fixed in 2.6.22-rc4 in commit 0939c17c7bcf1c838bea4445b80a6966809a438f

thanks,
-chris
