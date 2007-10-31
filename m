Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbXJaADb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbXJaADb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbXJaADV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:03:21 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:12505 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158AbXJaADU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eYcN8y8FQQwIM9E0ygz062m628pbQGA8wq11zuc5ZAH3yFlnaFLejMZdTLiOpCItXXmjuiFZFbrPYH69MoF8TOYMKBbaMCq11XtMLn9IPhPMH4W8tgz76jpxir5pHssYnEFlifUFVfiWw7HzGL5jZOs0CJnuo/cW7OGGtZGgYic=
Message-ID: <b1c6420f0710301703n5c330ae2idb75c9a5703d5e7c@mail.gmail.com>
Date: Wed, 31 Oct 2007 09:03:18 +0900
From: "Suzuki Takashi" <suzuki.takashi@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [Linux-am33-list] [PATCH 2/2] MN10300: Add the MN10300/AM33 architecture to the kernel [try #2]
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-am33-list@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20112.1193774645@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029122759.2846.83510.stgit@warthog.procyon.org.uk>
	 <20071029122809.2846.58795.stgit@warthog.procyon.org.uk>
	 <b1c6420f0710300740t5c708933x7ab1716c76504c57@mail.gmail.com>
	 <20112.1193774645@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/07, David Howells <dhowells@redhat.com> wrote:
> > Does this mean cpu-am33v3, cpu-am33v4, etc. will be created
> > when a new core comes up?
>
> Yes.  Note that the headers in a later one can 'inherit' from those of an
> earlier one simply by #including that earlier one, much like archs do with
> asm-generic headers.

GCC is willing to include the earlier one.
But people aren't, are they?

If cpu-am33v3/cpu-regs.h #includes cpu-am33v2/cpu-regs.h,
people have to
1) open cpu-am33v3/cpu-regs.h,
saying #include <asm/cpu-am33v2/cpu-regs.h> (and sigh).
2) open cpu-am33v2/cpu-regs.h.

This decreases development efficiency.
If there is no difference and they are all #including only headers,
there is nothing but development efficiency decrease.
It is not too late to split into directories
only after some large difference to the earlier one comes on.

And at that time asm/cpu-regs.h should #include cpu/cpu-regs.h and
people would #include asm/cpu-regs.h for the general purpose so that
they aren't confused which is cpu-specific and which is proc-specific.

> > Isn't it possible to split codes by features, instead of target cores?
>
> Perhaps, but I personally am not in a position to judge what features are
> common to what CPUs.  I'll have to let someone from MEI answer that one.  I'll
> discuss it with them.

Ok. I'll wait.

> > Stranger names here.
>
> How so?

The file is under cpu/, but the names are mn103e010_* which is proc-specific.


-- 
Suzuki Takashi
Japan
