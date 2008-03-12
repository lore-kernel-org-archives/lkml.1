Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbYCLRfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbYCLRfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbYCLReS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:34:18 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:27283 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbYCLReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:34:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xIHW8xQBNRJFhstHfzUP4tb5Euq/aRjHhOthOswbOgcBciehXqfx/Qjb37S+wzz46s6GJWUU6XwhCxD/H7+bqfUmJX9hs93WLY9sg/0eA6FowroN0Huoak6glBUZ9NkUo3qQAL9R106PG9iJbINrWuKRqahsdx9U6n27CE1Zygc=
Subject: Re: [PATCH 1/6] kernel: add clamp(), clamp_t() and clamp_val()
	macros
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <200803121820.14883.mb@bu3sch.de>
References: <1205269894.22317.32.camel@brick>
	 <200803121613.09172.mb@bu3sch.de> <1205340866.8603.9.camel@brick>
	 <200803121820.14883.mb@bu3sch.de>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 10:34:09 -0700
Message-Id: <1205343249.8603.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 18:20 +0100, Michael Buesch wrote:
> On Wednesday 12 March 2008 17:54:26 Harvey Harrison wrote:
> > On Wed, 2008-03-12 at 16:13 +0100, Michael Buesch wrote:
> > > So why not call it clamp_const()?
> > > One could even use __builtin_constant_p() and make clamp() use
> > > either clamp_const() or clamp_nonconst() from above automagically.
> > > I'd prefer that.
> > 
> > Did you mean something like this?  No more clamp_val, just clamp and
> > clamp_t.  clamp_t forces all the types, clamp looks at the min and max
> > args, and if they are constants, uses the type of val instead.  If not
> > a constant, the strict typechecking is done.
> 
> > +#define clamp(val, min, max) ({				\
> > +	typeof(val) __val = (val);			\
> > +							\
> > +	if (__builtin_constant_p(min)) {		\
> > +		typeof(val) __min = (min);		\
> > +		__val = __val < __min ? __min: __val;	\
> > +	} else {					\
> > +		typeof(min) __min = (min);		\
> > +		(void) (&__val == &__min);		\
> > +		__val = __val < __min ? __min: __val;	\
> > +	}						\
> > +							\
> > +	if (__builtin_constant_p(max)) {		\
> > +		typeof(val) __max = (max);		\
> > +		__val > __max ? __max: __val;		\
> > +	} else {					\
> > +		typeof(max) __max = (max);		\
> > +		(void) (&__val == &__max);		\
> > +		__val > __max ? __max: __val;		\
> > +	} })
> 
> Yeah, something like that.
> Does returning of the value work over an indentation level, too?
> I dunno this detail of the language.
> But I'd prefer the following for readability anyway:
> 
> +       if (__builtin_constant_p(max)) {                \
> +               typeof(val) __max = (max);              \
> +               __val = __val > __max ? __max: __val;           \
> +       } else {                                        \
> +               typeof(max) __max = (max);              \
> +               (void) (&__val == &__max);              \
> +               __val = __val > __max ? __max: __val;           \
> +       }
> +	__val; })

Yeah, that is better. (and even works).

Harvey

