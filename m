Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbZLKRqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbZLKRqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:46:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757366AbZLKRqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:46:36 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:41157 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068AbZLKRqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:46:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FMYlMAQKCHqvX2AajZyHWtL1wWZ/0zp5TwDLDAQrDZSwMAJWd/bBK1i2a9VvkoUkln
         rJVcDqWIgY8xrY3TMf65md8AiAUWUkQeCMqMzxFIezJWNotG5UFw3qdZ7DpNqYHCXiHy
         dLvkguD2tnbaaPjkLXm/al3vyLqOM/nOWC6uI=
Date: Fri, 11 Dec 2009 18:46:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Riss <frederic.riss@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ftrace: Fix MATCH_END_ONLY filter matching
Message-ID: <20091211174632.GC5094@nowhere>
References: <4B2217D0.5000308@cn.fujitsu.com> <87d3b2040912110420w270cff7ew36a7f2389a88fdb9@mail.gmail.com> <20091211122721.GH5244@nowhere> <1260544231.2146.360.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260544231.2146.360.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 10:10:31AM -0500, Steven Rostedt wrote:
> On Fri, 2009-12-11 at 13:27 +0100, Frederic Weisbecker wrote:
> > On Fri, Dec 11, 2009 at 01:20:04PM +0100, Frederic Riss wrote:
> > > 2009/12/11 Li Zefan <lizf@cn.fujitsu.com>:
> > > > For '*foo' pattern, we should allow any string ending with
> > > > 'foo', but ftrace filter incorrectly disallows strings
> > > > like bar_foo_foo:
> > > [...]
> > > >        case MATCH_END_ONLY:
> > > > -               ptr = strstr(str, regex);
> > > > -               if (ptr && (ptr[len] == 0))
> > > > +               slen = strlen(str);
> > > > +               if (slen >= len && memcpy(str + slen - len, regex, len))
> > > >                        matched = 1;
> > > 
> > > Shouldn't that be memcmp() == 0? I don't see how memcpy might serve as
> > > a compare operator.
> > > 
> > > Fred.
> > 
> > 
> > Oh you're right, I reviewed it too quickly. Perhaps the star's
> > alignment made it possible for only one Frederic to review it
> > the right way...
> > 
> 
> The stars are still fuzzy to me. How does memcpy work here?


It doesn't, I guess Li intended to use memcmp.

