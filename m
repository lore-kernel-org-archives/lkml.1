Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab0BCQTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:19:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40029 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab0BCQTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:19:06 -0500
X-Authority-Analysis: v=1.0 c=1 a=NqJWMTIrbqwA:10 a=7U3hwN5JcxgA:10 a=pxgYCMoEhMjBDvjSPncA:9 a=qG0wDyDZqgpFlZzohyA17ZP_FiEA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 3/3] kernel-shark: fix unitialized handle compile
 warnings
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: John Kacur <jkacur@redhat.com>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1265213851.24386.1.camel@gandalf.stny.rr.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
	 <1265043026-24987-4-git-send-email-dvhltc@us.ibm.com>
	 <520f0cf11002030805q35029925u36f544f7d37faedb@mail.gmail.com>
	 <1265213851.24386.1.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Feb 2010 11:19:05 -0500
Message-ID: <1265213945.24386.2.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 11:17 -0500, Steven Rostedt wrote:
> andle)
> > > -               handle = tracecmd_open(input_file);
> > > +       handle = tracecmd_open(input_file);
> > >
> > > -       info->handle = handle;
> > > +       if (handle)
> > > +               info->handle = handle;
> > >
> > >        /* --- Main window --- */
> > >
> > > --
> > 
> > This looks correct, but I'm wondering if it is safe to continue if the
> > call to tracecmd_open fails?
> 
> Actually this patch is wrong. The real code should be:
> 
> -	if (handle)
> +	if (input_file)

Looking at the context, this isn't enough. We should have had:

	if (input_file)
		info->handle = tracecmd_open(input_file);
	else
		info->handle = NULL;

-- Steve


