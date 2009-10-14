Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZJNSaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZJNSaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZJNSaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:30:04 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52700 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751095AbZJNSaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:30:03 -0400
Date: Wed, 14 Oct 2009 14:22:07 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: "Luck, Tony" <tony.luck@intel.com>
cc: Tejun Heo <tj@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       "mingo@redhat.com" <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "rostedt@goodmis.org" <rostedt@goodmis.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "cebbert@redhat.com" <cebbert@redhat.com>
Subject: RE: [PATCH 13/16] percpu: remove per_cpu__ prefix.
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E32264A8@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.DEB.1.10.0910141420300.9708@gentwo.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <57C9024A16AD2D4C97DC78E552063EA3E32264A8@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Luck, Tony wrote:

> But that would leave no visual indicator in the source
> code that a per-cpu variable was being used.  E.g. in
> delayed_tlb_flush() we'd end up with:

we would still have to use per cpu operations to get to the contents of
these variables.
>
>    if (unlikely(ia64_need_tlb_flush)) {

     if (unlikely(this_cpu_read(ia64_need_tlb_flush))
>        spin_lock ...
>        if (ia64_need_tlb_flush) {

	ditto.

>            local_flush_tlb_all();
>            ia64_need_tlb_flush = 0;

		this_cpu_write(ia64_need_tlb_flush, 0);
>        }
>        spin_unlock ...
>    }
>

Hope that addresses your concerns.

