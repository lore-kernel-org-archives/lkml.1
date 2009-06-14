Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbZFNQJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbZFNQJq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 12:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757601AbZFNQJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 12:09:21 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:56399 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbZFNQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 12:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=rEPV13S+4qPtlNnUkbyzkjrEdw5CGhSD9qHuwmfL0JBIrZ7fI5fTVpLLiLJcNAZGpw
         QdEfVEgIHMvOx5oONGulDtI4+Js0ZqgtSv81ibNaQwLkKCnOJhBWvId2fI0Q0KmXYh/q
         Wfmj3IIXh/x3b0wImG085sEmet8qi9vih9pu0=
Subject: Re: [PATCH 2/2 v2] ftrace: document basic ftracer/ftracer graph
 needs
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0906140845o73c4c9d6r40c2e1132a46fa6a@mail.gmail.com>
References: <1244623722-6325-2-git-send-email-vapier@gentoo.org>
	 <1244667129-27630-1-git-send-email-vapier@gentoo.org>
	 <1244992206.31584.59.camel@falcon>
	 <8bd0f97a0906140845o73c4c9d6r40c2e1132a46fa6a@mail.gmail.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Mon, 15 Jun 2009 00:09:12 +0800
Message-Id: <1244995752.31584.69.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Mike 

> >> +For information on how to implement prepare_ftrace_return(), simply look at
> >> +the x86 version.  The only architecture-specific piece in it is the setup of
> >> +the fault recovery table (the asm(...) code).  The rest should be the same
> >> +across architectures.
> >> +
> >
> > and the fault recovery table is not needed.
> 
> i dont have one for the Blackfin port, but that's more because there
> is no fault recovery support in the Blackfin port ;)
> 
> > In reality, the prepare_ftrace_return() can have the same arguments as
> > ftrace_trace_function()
> > ...
> > as i know, prepare_ftrace_return() is used to check whether the calling
> > function expect to trace, if yes, return the 'hook' function
> > &return_to_handler, otherwise, return back to the parent_ip directly.
> > so, here, i think there is no need to transfer the data via address, but
> > just using the same arguments like ftrace_trace_function does.
> 
> hmm, that would make the implementation simpler, but i dont think you
> could do that if you implemented the fault handler.  i cant really
> speak as to the requirement of the fault handler as i dont really know
> what/how it works -- i can only guess at they arent used in any way
> for Blackfin systems.
> 
> > unsigned long
> > prepare_ftrace_return(unsgined long ip, unsigned long parent_ip)
> > {
> >    [...]
> >    if (ftrace_push_return_trace(parent_ip, ip, &trace.depth) == -EBUSY)
> >        return parent_ip;
> >
> >    if (ftrace_graph_entry(&trace))
> >        return (unsigned long)&return_to_handler;
> >
> >    [...]
> >
> >    return parent_ip;
> > }
> >
> > if using the above method, the fault recovery table is not needed again.
> 
> and it would allow us to move this code into the common ftrace
> framework for people who dont do fault handlers.
> 

Perhaps I miss something here? otherwise, this fault handler is not
needed if not transfer the data via address and not modify the data in
the place *address accordingly.

best regards,
Wu Zhangjin

