Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbXJQFOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbXJQFOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXJQFOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:14:00 -0400
Received: from duempel.org ([81.209.165.42]:43060 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751477AbXJQFN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:13:59 -0400
Date: Wed, 17 Oct 2007 07:13:57 +0200
From: Max Kellermann <max@duempel.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /proc Security Hooks
Message-ID: <20071017051357.GA4515@roonstrasse.net>
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071016193850.GA5418@roonstrasse.net> <20071016125403.40ec5c18@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071016125403.40ec5c18@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007/10/16 21:54, Arjan van de Ven <arjan@infradead.org> wrote:
> On Tue, 16 Oct 2007 21:38:50 +0200
> Max Kellermann <mk@cm4all.com> wrote:
> > This patch attempts to unify duplicated code found in modules like
> > Linux VServer.
> 
> can you please merge this patch only when you also merge the first
> user
> of it? That's the only way we can keep the LSM hooks sane... is to
> see
> them in thew conect of a user.

I wrote a module which uses this, but it's non-free and only used on
my employer's servers.  But I could have a closer look at the Vserver
code and try to make it use my patch.

> > +#ifdef CONFIG_SECURITY_PROC
> > +           if (security_proc_task(task) != 0)
> > +                                        continue;
> > +#endif
> 
> please don't use an ifdef like this; just make security_proc_task()
> be
> a define to 0 in the header for that CONFIG_ .. 
> In addition, why is this a separate config option? LSM should really
> only be one big switch... microswitches like this don't make any
> sense.

Right, I initially wrote this patch some time ago when
linux/security.h didn't have an "#ifdef CONFIG_SECURITY".  I'll adapt
that.

> > +#ifdef CONFIG_SECURITY_PROC
> > +                           if (security_proc_generic(de) != 0)
> > +
> > goto skip;
> > +#endif
> 
> as does this one... but the goto looks horrid to me

I'm all against gotos, but seeing gotos all over the kernel, and my
code being in an #ifdef, this one goto looked "normal" to me.  You're
right, I should change it.

Max
