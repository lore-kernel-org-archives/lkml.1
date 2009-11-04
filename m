Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbZKDRTO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbZKDRTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:19:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbZKDRTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:19:13 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:39162 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290AbZKDRTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:19:13 -0500
Date: Wed, 4 Nov 2009 18:19:16 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the
	kernel (__ksymtab)
Message-ID: <20091104171916.GA6323@merkur.ravnborg.org>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com> <1257242782-10496-6-git-send-email-alan-jenkins@tuffmail.co.uk> <200911041849.43311.rusty@rustcorp.com.au> <4AF150D2.6000207@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF150D2.6000207@tuffmail.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 10:00:50AM +0000, Alan Jenkins wrote:
> Rusty Russell wrote:
>> On Tue, 3 Nov 2009 08:36:17 pm Alan Jenkins wrote:
>>   
>>> +/*
>>> + * We use CPP macros since they are more familiar than assembly macros.
>>> + * Note that CPP macros eat newlines, so each statement must be terminated
>>> + * by a semicolon.
>>> + */
>>> +
>>> +#ifdef CONFIG_HAVE_SYMBOL_PREFIX
>>> +#define __SYM(sym) _##sym
>>> +#else
>>> +#define __SYM(sym) sym
>>> +#endif
>>>     
>>
>> Ideally, you would used MODULE_SYMBOL_PREFIX here, but of course it's a
>> string.  I don't think Kconfig can do arbitrary identifiers, so we can't
>> make CONFIG_SYMBOL_PREFIX empty or _.
>>
>> Perhaps clarify it to a bool CONFIG_HAVE_MODULE_UNDERSCORE_PREFIX then,
>> since that's what you're assuming here?
>>
>> Thanks,
>> Rusty.
>
> I made the same assumption in patch 4.  The arch defines  
> CONFIG_HAVE_SYMBOL_PREFIX, which then causes init/Kconfig to define  
> CONFIG_SYMBOL_PREFIX="_".
>
> Mike suggested that I hack kbuild instead, to do something like
>
> unquote = ...
> AFLAGS_.tmp_export-asm.o += -DSYMBOL_PREFIX=$(unquote CONFIG_SYMBOL_PREFIX)
>
> I'm experimenting with the idea, but I haven't managed to get it working  

Something like this:
unquote = $(patsubst "%",%,$($1))

AFLAGS_.tmp_export-asm.o += -DSYMBOL_PREFIX=$(call unquote,CONFIG_SYMBOL_PREFIX)

But the readability is low so we could be better off doing it direct:

AFLAGS_.tmp_export-asm.o += -DSYMBOL_PREFIX=$(patsubst "%",",$(CONFIG_SYMBOL_PREFIX))

	Sam
