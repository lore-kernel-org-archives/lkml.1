Return-Path: <linux-kernel-owner+w=401wt.eu-S1762592AbYBWJ1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762592AbYBWJ1g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 04:27:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbYBWJ1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 04:27:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:32922 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbYBWJ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 04:27:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=Y1dQDeKDH4QPfpsZ1HOv1117QIao4gVJoknTm4i7fwxtqbJOOVwv9ZnyJNMxI3J/7ShQj7IIh57oKnKvXr3mj+0qOVJqd68KEq2D5kWVi3Bn3YO/BKuZ9g3mlFuCmGKw3o0o+jd1V6cQFr+7isJ+oeQzYLMfYm3x0JoKN8//CGo=
Date: Sat, 23 Feb 2008 12:27:10 +0300
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] (Resend) Use get_personality()
Message-ID: <20080223092710.GD2262@martell.zuzino.mipt.ru>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com> <20080223085101.GC2262@martell.zuzino.mipt.ru> <20080223.165944.37229792.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223.165944.37229792.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 04:59:44PM +0800, WANG Cong wrote:
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Subject: Re: [PATCH 00/16] (Resend) Use get_personality()

> > On Sat, Feb 23, 2008 at 04:14:03PM +0800, WANG Cong wrote:
> > > This patchset makes the macro get_personality function alike
> > > and teaches code to use get_personality() instead of explicit
> > > reference.
> > > 
> > > [I am sorry if you've received multiple copied of this, since
> > >  my git-send-email doesn't work well. ]
> > 
> > Yes, but why? "current->personality" is way more understandable than
> > your macro because task subject to dereference is very visible.
> 
> Use get_personality() can hide the task_struct internals a bit.

->personality is going to become something less trivial?
Sorry, but you sound like C++ people writing tons of pointless get/set
wrappers. And your get_personality() is worse -- C++ would write it as

	current->personality()

and again, even here, it's immediately visible that current task is
involved, not some other task.

> And I don't think using the macro to access it is less understandable.
> Since 'current' won't be NULL, whether the dereference is visible is
> not important.

It's not about NULL vs non-NULL at all.
