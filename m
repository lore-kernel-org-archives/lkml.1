Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYESFsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYESFsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 01:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbYESFsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 01:48:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:63255 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbYESFsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 01:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Nu6VcdKkooe5H4o53aIdnv/9bqsyFsc7CfD1mb+t5zfxcf/hxHw5sdGGmkVRRDseSNe1Wd4CpMGbVFJNNbJwnZx7SL/+Zphh1I0ynnonVAiLZeof8rIEneBPzNTXd3MObU488rAuO9ok9wKhPrIyhXOFhgOuWmOaq5NMU9CnJ5U=
Date: Mon, 19 May 2008 10:43:45 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] ERR_PTR: warn when ERR_PTR parameter is not errno
	value
Message-ID: <20080519064345.GB4707@martell.zuzino.mipt.ru>
References: <20080513201813.GA5869@joi> <1211148273-16226-1-git-send-email-marcin.slusarz@gmail.com> <87hccvurxr.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hccvurxr.fsf@saeurebad.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 01:13:20AM +0200, Johannes Weiner wrote:
> Marcin Slusarz <marcin.slusarz@gmail.com> writes:
> 
> > Check at runtime whether error argument of ERR_PTR and ERR_OR_0_PTR
> > is valid. It can catch bugs which possibly lead to oops or panic earlier.
> >
> > Currently there are > 600 calls of ERR_PTR with non-constant argument
> > in Linux kernel sources.

> > --- a/include/linux/err.h
> > +++ b/include/linux/err.h
> > @@ -3,6 +3,7 @@
> >  
> >  #include <linux/compiler.h>
> >  
> > +#include <asm/bug.h>
> >  #include <asm/errno.h>
> >  
> >  /*
> > @@ -21,6 +22,7 @@
> >  
> >  static inline void *__ERR_PTR(long error)
> >  {
> > +	WARN_ON(!IS_ERR_VALUE(error));
> >  	return (void *) error;
> >  }
> >  
> > @@ -28,6 +30,7 @@ static inline void *__ERR_PTR(long error)
> >  
> >  static inline void *__ERR_OR_0_PTR(long error)
> >  {
> > +	WARN_ON(!IS_ERR_VALUE(error) && error);
> >  	return (void *) error;
> >  }
> 
> How about WARN_ON_ONCE() instead?  That would warn once for each erroneous user
> which should be enough.

And blow up .bss ?

