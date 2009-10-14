Return-Path: <linux-kernel-owner+w=401wt.eu-S1761936AbZJNS7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761936AbZJNS7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbZJNS7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:59:12 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:55478 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754882AbZJNS7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:59:10 -0400
Date: Wed, 14 Oct 2009 14:51:02 -0400 (EDT)
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
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E3226704@orsmsx505.amr.corp.intel.com>
Message-ID: <alpine.DEB.1.10.0910141445110.30078@gentwo.org>
References: <1255500125-3210-1-git-send-email-tj@kernel.org> <1255500125-3210-14-git-send-email-tj@kernel.org> <alpine.DEB.1.10.0910141026370.26476@gentwo.org> <57C9024A16AD2D4C97DC78E552063EA3E32264A8@orsmsx505.amr.corp.intel.com> <alpine.DEB.1.10.0910141420300.9708@gentwo.org>
 <57C9024A16AD2D4C97DC78E552063EA3E3226704@orsmsx505.amr.corp.intel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Oct 2009, Luck, Tony wrote:

> > we would still have to use per cpu operations to get to the contents of
> > these variables.
>
> That's good.
>
> > Hope that addresses your concerns.
>
> But then I don't understand the original patch that was going to do:
>
> > -#define __ia64_per_cpu_var(var)	per_cpu__##var
> > +#define __ia64_per_cpu_var(var)	var
>
> Presumably all actual use of __ia64_per_cpu_var is being replaced
> by some other "per cpu operations"?

Hmmm... Right. IA64 is a special case because the access of the per cpu
variable at a specific address causes per cpu TLBs to do the relocation.

Other platforms have to add a per cpu specific offset to a variable to get
the right per cpu variable.

As a result IA64 strictly does not need this_cpu_read() and
this_cpu_write(). However, not using the operations is going to cause
the sparse annotation by Tejun to trigger errors. this_cpu_read() is
likely a noop for IA64 that just changes the annotations so that sparse
warnings do not trigger. Tejun?

