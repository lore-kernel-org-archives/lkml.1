Return-Path: <linux-kernel-owner+w=401wt.eu-S1756415AbZFWVJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415AbZFWVJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbZFWVJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:09:26 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47999 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbZFWVJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:09:25 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 23 Jun 2009 14:03:22 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, avi@redhat.com,
       kvm@vger.kernel.org, ghaskins@novell.com,
       Rusty Russell <rusty@rustcorp.com.au>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch] eventfd - revised interface and cleanups (2nd rev)
In-Reply-To: <20090623131848.b876d42e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0906231400010.17001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906230936280.17001@makko.or.mcafeemobile.com> <alpine.DEB.1.10.0906231219450.17001@makko.or.mcafeemobile.com> <20090623131848.b876d42e.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009, Andrew Morton wrote:

> On Tue, 23 Jun 2009 12:25:36 -0700 (PDT)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > The following patch changes the eventfd interface to de-couple the eventfd 
> > memory context, from the file pointer instance.
> > Without such change, there is no clean way to racely free handle the 
> > POLLHUP event sent when the last instance of the file* goes away.
> > Also, now the internal eventfd APIs are using the eventfd context instead 
> > of the file*.
> > Another cleanup this patch does, is making AIO select EVENTFD, instead of 
> > adding a bunch of empty function stubs inside eventfd.h in order to 
> > handle the (AIO && !EVENTFD) case.
> > 
> > ...
> >
> > +/**
> > + * eventfd_ctx_get - Acquires a reference to the internal eventfd context.
> > + * @ctx: [in] Pointer to the eventfd context.
> > + *
> > + * Returns: In case of success, returns a pointer to the eventfd context,
> > + *          otherwise a proper error code.
> 
> The description of the return value

Should functions be describing all the returned error codes, ala man pages?



> > + */
> > +struct eventfd_ctx *eventfd_ctx_get(struct eventfd_ctx *ctx)
> > +{
> > +	kref_get(&ctx->kref);
> > +	return ctx;
> > +}
> > +EXPORT_SYMBOL_GPL(eventfd_ctx_get);
> 
> doesn't match the code.
> 
> Also...
> 
> > + * Returns: A pointer to the eventfd file structure in case of success, or a
> > + *          proper error pointer in case of failure.
> 
> 
> > + * Returns: In case of success, it returns a pointer to the internal eventfd
> > + *          context, otherwise a proper error code.
> > + */
> 
> I'm unsure what the word "proper" means in this context.
> 
> The term "proper error pointer" is understandable enough - something
> you run IS_ERR() against.  "error pointer" would suffice.
> 
> But the term "proper error code" is getting a bit remote from reality.
> 
> Unfortunately the kernel doesn't have a simple and agreed-to term for
> an ERR_PTR() thingy.  Perhaps we should invent one.  "err_ptr"?

OK, but you tricked me once again :)
You posted your comments/changes while you merged the old version in -mm 
already.



- Davide


