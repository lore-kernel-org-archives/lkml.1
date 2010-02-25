Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690Ab0BYOJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 09:09:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57489 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab0BYOJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 09:09:28 -0500
X-Authority-Analysis: v=1.0 c=1 a=wyP15y6EwVoA:10 a=7U3hwN5JcxgA:10 a=1nSz6Ew-AAAA:8 a=QUYj05VZHuikCgi2vaUA:9 a=pVVhXaEHSxsmMa3kSUQA:7 a=eC5Gj6oq1uMKpoYkXCaHkBJZGFkA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] ftrace: fix ftrace_event_call alignment for use with
 gcc 4.5
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jeff Mahoney <jeffm@suse.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4B857F00.10005@suse.com>
References: <4B85770B.6010901@suse.com>  <4B857F00.10005@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Feb 2010 09:09:25 -0500
Message-ID: <1267106965.24271.8788.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 14:33 -0500, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 02/24/2010 01:59 PM, Jeff Mahoney wrote:
> >  GCC 4.5 introduces behavior that forces the alignment of structures to
> >  use the largest possible value. The default value is 32 bytes, so if
> >  some structures are defined with a 4-byte alignment and others aren't
> >  declared with an alignment constraint at all - it will align at 32-bytes.
> > 
> >  For things like the ftrace events, this results in a non-standard array.
> >  When initializing the ftrace subsystem, we traverse the _ftrace_events
> >  section and call the initialization callback for each event. When the
> >  structures are misaligned, we could be treating another part of the
> >  structure (or the zeroed out space between them) as a function pointer.
> > 
> >  This patch forces the alignment for all the ftrace_event_call structures
> >  to 4 bytes.
> > 
> >  Without this patch, the kernel fails to boot very early when built with
> >  gcc 4.5.
> > 
> >  It's trivial to check the alignment of the members of the array, so it
> >  might be worthwhile to add something to the build system to do that
> >  automatically. Unfortunately, that only covers this case. I've asked one
> >  of the gcc developers about adding a warning when this condition is seen.
> 
> BTW, the analysis for this is available here:
> 
> https://bugzilla.novell.com/show_bug.cgi?id=582222
> 

Thanks! I'll apply this and push it forward (as well as to stable)

-- Steve

