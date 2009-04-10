Return-Path: <linux-kernel-owner+w=401wt.eu-S1765995AbZDJNRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765995AbZDJNRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 09:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbZDJNQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 09:16:59 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56794 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbZDJNQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 09:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rjdJonOcoT5LC/JPQ182Ayrrdh4i2m690dKUI5Ke9MzX2imBh3CTNwx2y6ykq8zn4j
         ZF+cgZbU35ytgDOycNITDOnitft/xZ7g4uRFPIJuGRGgHtUJ40cEG1FppFxWTOpGe8oN
         QFUHbeu+bDHLvLzv4GiJvc27tUAcDG+lmqVXQ=
Date: Fri, 10 Apr 2009 17:17:01 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       orenl@cs.columbia.edu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/30] headers: fixup cred.h, ipc_namespace.h
Message-ID: <20090410131701.GA3683@x200.localdomain>
References: <20090410023248.GB27788@x200.localdomain> <20090410084747.GB17962@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410084747.GB17962@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 10:47:47AM +0200, Ingo Molnar wrote:
> 
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:

> > +struct kern_ipc_perm;

> Please, not yet another forward declaration...
> 
> I believe this should be cleaned up properly, instead of sprinkling 
> the kernel with random placed forward declarations.

It's at the top of the file, there is no random placing going on.

> In a cleanly structured piace of code there's rarely any need for 
> forward declarations like this. There's two basic header types 
> needed:
> 
>    foo_types.h       declares all the data types and constants
>                      [no complex inline functions]
> 
>    foo.h             externs, complex inlines
> 
> foo.h includes all foo_types.h and bar_types.h headers it needs.
> 
> The foo_types.h file includes all other bar_types.h headers it 
> depends on for its data type definitions.
> 
> foo_types.h never includes a bar.h file.

This can be viewed as bad precedent created by mm_types.h.

Look how many headers mm_types.h includes. It doesn't change much
if one includes mm.h or mm_types.h.

Look how many places includes spinlock_types.h

> The end result will be a clean hieararchy of data types, separated 
> from methods. Complex inlines dont create the incestous 
> cross-dependency hell anymore and dont contaminate the foo_types.h 
> files.
> 
> Yes, this is quite a bit of work, but this has been done before for 
> several complex headers so it's possible to do it.

Forward declarations are currently well established.

Want to change rules? Fine, do it.
