Return-Path: <linux-kernel-owner+w=401wt.eu-S1765623AbZDJJDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765623AbZDJJDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbZDJJDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:03:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637AbZDJJDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:03:02 -0400
Date: Fri, 10 Apr 2009 11:01:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@gmail.com>, Andy Whitcroft <apw@canonical.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/30] ipcns: add create_ipc_ns()
Message-ID: <20090410090149.GD17962@elte.hu>
References: <20090410023358.GE27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023358.GE27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@gmail.com> wrote:

> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -97,6 +97,7 @@ static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
>  
>  #if defined(CONFIG_IPC_NS)
>  extern void free_ipc_ns(struct ipc_namespace *ns);
> +struct ipc_namespace *create_ipc_ns(void);
>  extern struct ipc_namespace *copy_ipcs(unsigned long flags,
>  				       struct ipc_namespace *ns);
>  extern void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,

Hm, doesnt the existing, correct pattern strike your eyes out:

  extern foo1();
  extern foo2();
  extern foo3();

and then you add a new method in this inconsistent way:

  extern foo1();
  foox();
  extern foo2();
  extern foo3();

Instead of continuing the existing pattern via:

  extern foo1();
  extern foox();
  extern foo2();
  extern foo3();

?

I think we need a new checkpatch warning for such things. It might 
be a small detail in the big picture, but a thousand small details 
create a big mess easily so we have to try to get all the small 
details right, all the time - that is the only way to create a 
better kernel in the end.

Thanks,

	Ingo
