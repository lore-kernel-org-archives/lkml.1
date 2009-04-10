Return-Path: <linux-kernel-owner+w=401wt.eu-S934854AbZDJLZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854AbZDJLZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 07:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758649AbZDJLZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 07:25:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:13410 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbZDJLZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 07:25:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fNIrzZsJf+HKPuXjfkyKF6V+EiFlZ4sbSjxGOW7+eZClY7fNRp7cZ1rZf+gNsen0Gc
         0gLEZK+iMWE1dn8k0jJA/hMVeO2dfSUvLA2fVxNnmPqoOz5Wi2BCQBzn4NlPSzkW2RU6
         JpG7671cVOy6QEsTup5rAemHAceKEDwr8i8wA=
Date: Fri, 10 Apr 2009 15:25:32 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@canonical.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       serue@us.ibm.com, dave@linux.vnet.ibm.com, orenl@cs.columbia.edu,
       hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/30] ipcns: add create_ipc_ns()
Message-ID: <20090410112532.GB3311@x200.localdomain>
References: <20090410023358.GE27788@x200.localdomain> <20090410090149.GD17962@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410090149.GD17962@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 11:01:49AM +0200, Ingo Molnar wrote:
> 
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > --- a/include/linux/ipc_namespace.h
> > +++ b/include/linux/ipc_namespace.h
> > @@ -97,6 +97,7 @@ static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
> >  
> >  #if defined(CONFIG_IPC_NS)
> >  extern void free_ipc_ns(struct ipc_namespace *ns);
> > +struct ipc_namespace *create_ipc_ns(void);
> >  extern struct ipc_namespace *copy_ipcs(unsigned long flags,
> >  				       struct ipc_namespace *ns);
> >  extern void free_ipcs(struct ipc_namespace *ns, struct ipc_ids *ids,
> 
> Hm, doesnt the existing, correct pattern strike your eyes out:
> 
>   extern foo1();
>   extern foo2();
>   extern foo3();
> 
> and then you add a new method in this inconsistent way:
> 
>   extern foo1();
>   foox();
>   extern foo2();
>   extern foo3();
> 
> Instead of continuing the existing pattern via:
> 
>   extern foo1();
>   extern foox();
>   extern foo2();
>   extern foo3();
> 
> ?
> 
> I think we need a new checkpatch warning for such things. It might 
> be a small detail in the big picture, but a thousand small details 
> create a big mess easily so we have to try to get all the small 
> details right, all the time - that is the only way to create a 
> better kernel in the end.

We (OK, I don't care anyway) should remove extern in front of prototypes.

They slow down compilation, they make easier to overcome 80-column limit resulting in
multiline prototypes which are ugly.
