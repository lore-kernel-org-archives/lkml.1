Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYH3PE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYH3PE2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 11:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754061AbYH3PEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 11:04:14 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:43993 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYH3PEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 11:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cLSI2rCC3DEDfNRJ/qpllRdLqBG0jmrOMhQXibQWzXzz5+55dwfO0k3/93MkiKs5GS
         VCfVbDC1hjrjlylRAv/IX9cPlZDsd9sufQ+H/UO0aYwoCkzRbASc6d0wr+xocXeaYGfx
         IHu+icfMHMHJaVP2AkAYGmxhkMEJEqevIC7v8=
Date: Sat, 30 Aug 2008 19:05:45 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
Message-ID: <20080830150545.GA29686@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220157.397C7154233@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826220157.397C7154233@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 03:01:57PM -0700, Roland McGrath wrote:
> +/**
> + * struct utrace_attached_engine - per-engine structure
> + * @ops:	&struct utrace_engine_ops pointer passed to utrace_attach_task()
> + * @data:	engine-private &void * passed to utrace_attach_task()
> + * @flags:	event mask set by utrace_set_events() plus internal flag bits
> + *
> + * The task itself never has to worry about engines detaching while
> + * it's doing event callbacks.  These structures are removed from the
> + * task's active list only when it's stopped, or by the task itself.
> + *
> + * utrace_engine_get() and utrace_engine_put() maintain a reference count.
> + * When it drops to zero, the structure is freed.  One reference is held
> + * implicitly while the engine is attached to its task.
> + */
> +struct utrace_attached_engine {
> +/* private: */
> +	struct kref kref;

Engine grew a refcount.

Was it added to fix some bug?

Old utrace git doesn't have this, new utrace git has only two
posted patches, so asking.

