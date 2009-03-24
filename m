Return-Path: <linux-kernel-owner+w=401wt.eu-S1762318AbZCXTuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762318AbZCXTuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbZCXTug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:50:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:34278 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbZCXTuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:50:35 -0400
Message-ID: <49C93960.1090403@kernel.org>
Date: Tue, 24 Mar 2009 12:49:52 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] Correct behaviour of irq affinity?
References: <200903241619.03517.rusty@rustcorp.com.au> <m1k56frt6e.fsf@fess.ebiederm.org>
In-Reply-To: <m1k56frt6e.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Also now that I look at it there is one other bug in this routine
> that you have missed.  set_extra_move_desc should be called before
> we set desc->affinity, as it compares that with the new value to
> see if we are going to be running on a new cpu, and if so we may
> need to reallocate irq_desc onto a new numa node.  set_extra_move_desc
> looks a little fishy but it doesn't stand a chance if it is called
> with the wrong data.


you are right, that is introduce bycommit 22f65d31b25a320a5246592160bcb102d2791c45

Author: Mike Travis <travis@sgi.com>
Date:   Tue Dec 16 17:33:56 2008 -0800

    x86: Update io_apic.c to use new cpumask API
    
    Impact: cleanup, consolidate patches, use new API
    
    Consolidate the following into a single patch to adapt to new
    sparseirq code in arch/x86/kernel/io_apic.c, add allocation of
    cpumask_var_t's in domain and old_domain, and reduce further
    merge conflicts.  Only one file (arch/x86/kernel/io_apic.c) is
    changed in all of these patches.
    
        0006-x86-io_apic-change-irq_cfg-domain-old_domain-to.patch
        0007-x86-io_apic-set_desc_affinity.patch
        0008-x86-io_apic-send_cleanup_vector.patch
        0009-x86-io_apic-eliminate-remaining-cpumask_ts-from-st.patch
        0021-x86-final-cleanups-in-io_apic-to-use-new-cpumask-AP.patch

will send one patch for that.

YH

