Return-Path: <linux-kernel-owner+w=401wt.eu-S1758547AbYESMLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547AbYESMLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYESMLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:11:45 -0400
Received: from saeurebad.de ([85.214.36.134]:33324 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbYESMLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:11:44 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] ERR_PTR: warn when ERR_PTR parameter is not errno value
References: <20080513201813.GA5869@joi>
	<1211148273-16226-1-git-send-email-marcin.slusarz@gmail.com>
	<87hccvurxr.fsf@saeurebad.de>
	<20080519064345.GB4707@martell.zuzino.mipt.ru>
Date: Mon, 19 May 2008 14:11:21 +0200
In-Reply-To: <20080519064345.GB4707@martell.zuzino.mipt.ru> (Alexey Dobriyan's
	message of "Mon, 19 May 2008 10:43:45 +0400")
Message-ID: <8763tav6hi.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Alexey Dobriyan <adobriyan@gmail.com> writes:

> On Mon, May 19, 2008 at 01:13:20AM +0200, Johannes Weiner wrote:
>> Marcin Slusarz <marcin.slusarz@gmail.com> writes:
>> 
>> > Check at runtime whether error argument of ERR_PTR and ERR_OR_0_PTR
>> > is valid. It can catch bugs which possibly lead to oops or panic earlier.
>> >
>> > Currently there are > 600 calls of ERR_PTR with non-constant argument
>> > in Linux kernel sources.
>
>> > --- a/include/linux/err.h
>> > +++ b/include/linux/err.h
>> > @@ -3,6 +3,7 @@
>> >  
>> >  #include <linux/compiler.h>
>> >  
>> > +#include <asm/bug.h>
>> >  #include <asm/errno.h>
>> >  
>> >  /*
>> > @@ -21,6 +22,7 @@
>> >  
>> >  static inline void *__ERR_PTR(long error)
>> >  {
>> > +	WARN_ON(!IS_ERR_VALUE(error));
>> >  	return (void *) error;
>> >  }
>> >  
>> > @@ -28,6 +30,7 @@ static inline void *__ERR_PTR(long error)
>> >  
>> >  static inline void *__ERR_OR_0_PTR(long error)
>> >  {
>> > +	WARN_ON(!IS_ERR_VALUE(error) && error);
>> >  	return (void *) error;
>> >  }
>> 
>> How about WARN_ON_ONCE() instead?  That would warn once for each erroneous user
>> which should be enough.
>
> And blow up .bss ?

Well, okay.  Perhaps ratelimiting?  I really prefer a bigger image size
over a spammed dmesg.

	Hannes
