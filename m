Return-Path: <linux-kernel-owner+w=401wt.eu-S1752128AbZA0VPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbZA0VPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 16:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZA0VO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 16:14:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:63469 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbZA0VO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 16:14:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=o6lZGhDViyng61CTg8B0SeEJJZWvsRGn14DtCeGG5UA2D7ifCdGOraCWL4Mh/XA7Lg
         Nxh/jVZggOYbHBTo/3Vk5Xif8b+Vc0mBLmlmF+J573u7+3l1/QwKd5PQQplzK7ylrH4u
         rN2iNElKCJ33KXk0yKCRXEp7sRmE5HYM8/qF0=
Date: Tue, 27 Jan 2009 22:14:53 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       powertop ml <power@bughost.org>,
       Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       srostedt@redhat.com, "Frank Ch. Eigler" <fche@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] tracer for sys_open() - sreadahead
Message-ID: <20090127211452.GA5850@nowhere>
References: <497F69A4.2070007@intel.com> <20090127205137.GD15877@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127205137.GD15877@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 06:51:37PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jan 27, 2009 at 12:08:04PM -0800, Kok, Auke escreveu:
> > This tracer monitors regular file open() syscalls. This is a fast
> > and low-overhead alternative to strace, and does not allow or
> > require to be attached to every process.
> > 
> > The tracer only logs succesfull calls, as those are the only ones we
> > are currently interested in, and we can determine the absolute path
> > of these files as we log.
> > 
> > Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
> 
> <SNIP>
>  
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index 4d3d381..24c17d2 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -30,6 +30,7 @@ enum trace_type {
> >         TRACE_USER_STACK,
> >         TRACE_HW_BRANCHES,
> >         TRACE_POWER,
> > +       TRACE_OPEN,
> 
> Why not a TRACE_VFS or TRACE_SYSCALL and then multiplex there open,
> close, etc? trace_assign_type will get humongous in no time this way.


That's what I was about to answer too.
That would be sad to find one tracer for open, one for read, one for write...

 
> TRACE_BLK does multiplexing, as does TRACE_PROCESS that Frank just
> posted too, and I'm working on a plugin for the patch that Neil
> submitted for the socket layer that also will need an entry there for
> its tracepoints.
> 
> Frederic, it seems that discussion about subtypes has to continue :-)


Indeed, that becomes serious :-)

