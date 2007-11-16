Return-Path: <linux-kernel-owner+w=401wt.eu-S934393AbXKPAfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934393AbXKPAfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760323AbXKPAe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:34:57 -0500
Received: from nz-out-0506.google.com ([64.233.162.238]:49412 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976AbXKPAe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:34:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bjuwPUbTjcxxx1ap+/d+G/LiwqmXDroVLoqDY2Fa+YGDx3qHAtAki8LM+LsuVU8Wx1na0DlV99Eg0dQSqnEVIom5ghjSNbrQvbHHCpNuZpwII0bY/Bhvb1CmFEnh7ezqFsAIL4a85ndb0idULlKfb4cp2AsFvO+TLT2rplR8byU=
Message-ID: <9a8748490711151634t6d8cfb5tf8c3953c74a6b9a3@mail.gmail.com>
Date: Fri, 16 Nov 2007 01:34:54 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: mm_release() call in exit_mm() looks dangerous
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4738F442.3040905@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490711111540q10503eday7f06b3e72b20fe82@mail.gmail.com>
	 <4738F442.3040905@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/2007, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Jesper Juhl wrote:
> > In kernel/exit.c we have this code :
> >
> > static void exit_mm(struct task_struct * tsk)
> > {
> >         struct mm_struct *mm = tsk->mm;
> >
> >         mm_release(tsk, mm);
> >         if (!mm)
> >                 return;
> > ...
> >
> >
> > But, mm_release() may dereference it's second argument ('mm'), so
> > shouldn't we be doing the "!mm" test *before* we call mm_release() and
> > not after?
> > I don't know the mm code well enough to be able to tell if some of the
> > other stuff mm_release does needs to be done always and the mm
> > dereference can't actually happen, but maybe someone else who knows
> > the code better can tell...  In any case, what's currently there looks
> > a little shaky..
> >
>
> Yeah, it looks wrong.  mm_release() calls deactivate_mm() as its first
> act, which could well dereference mm (though it often doesn't).
>
So, whould simply moving the !mm check up as the first in the function
be an appropriate way to deal with this?

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
