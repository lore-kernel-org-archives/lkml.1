Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbZDNP1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbZDNP1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZDNP1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:27:41 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:14970 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZDNP1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:27:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qMvNrj3UmhWLIW6T1vtC++aYv/ZT13pDCoHGjVKw2CtM42kizOe5AZvy8OKIywW9YW
         8kE5gIlsKxx8zn4VH8uROuV7xPpy9r9X5sh1H384P8oNkT4bvPUY2sZqUoqSzLPeJL36
         sF4cV9OhS0MD4wmf8zu5fhnwWwEcFLUgROF1A=
Date: Tue, 14 Apr 2009 19:27:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, dave@linux.vnet.ibm.com, mingo@elte.hu,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/30] cr: core stuff
Message-ID: <20090414152752.GC27461@x200.localdomain>
References: <20090410023539.GK27788@x200.localdomain> <20090413214701.GA24509@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413214701.GA24509@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 04:47:01PM -0500, Serge E. Hallyn wrote:
> Quoting Alexey Dobriyan (adobriyan@gmail.com):
> 
> Hi Alexey,
> 
> as far as I can see, the main differences between this patch and the
> equivalent in Oren's tree are:
> 
> 1. kernel auto-selects container init to freeze

Note, auto-select part was dropped, userspace is required to pass pid of
container init exactly. This was done to keep semantic of checkpoint(2)
small and extendable.

> 2. kernel freezes tasks
> 3. no objhash taking references

That's because none needed.

> 4. no hbuf

hbuf is an optimization to not allocate/free memory for every image.
For a start it's unnecessary complication, I just kzalloc/dump/kfree.

> 5. always require CAP_SYS_ADMIN
> 
> Are there other differences which you would consider meaningful?  Which
> do you consider the most important?
> 
> Also, since Dave introduced the fops->checkpoint(), we (or at least I)
> have been struck by the ugly assymetry with checkpoint() being in fops,
> and restart() not.  Do you have an idea for fixing that?

Module can legally support C/R for its files.

In the end it most certainly will end up with module registering restart
hook for file type N.

Or module registering hook to restart object type N.

This is for discussion.
