Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZJCLg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZJCLg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 07:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbZJCLg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 07:36:28 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:33719 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbZJCLg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 07:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=do451Zyas2zzfJqI/EltG/H/ZOYYd+uz2nbEPqVclM05/X/3C/BzxuCBrv/wiArBkB
         rtsUY++Ir0KjBUpVfrcqHaWyCiNJGdb6hVxUtiho9ppRbvsbqcLrasgpc2xxNvnCf4WG
         wHZJ9eEoY7XwyTZbZ2NAnQtR/l1kS//k1/LBk=
Date: Sat, 3 Oct 2009 13:36:29 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
Message-ID: <20091003113627.GA6366@nowhere>
References: <20090924201622.GA15459@elte.hu> <1253824200.18939.173.camel@laptop> <20090924204357.GB8662@nowhere> <1253825489.18939.180.camel@laptop> <20090924213631.GA2661@nowhere> <1253866792.10287.0.camel@twins> <20090925091229.GB4686@nowhere> <1253871601.10287.23.camel@twins> <20090925103806.GA6467@nowhere> <1253961861.12145.148.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253961861.12145.148.camel@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 06:44:21AM -0400, Steven Rostedt wrote:
> 
> Perhaps when we put full perl regex into the kernel (my goal ;-) then we
> should look to keep different kinds of equals.
> 
>   ==  - is direct match. Only use of strcmp is needed.
> 
>   ~ - is globing. We can add a '*' which means match anything.
> 
> and if we do add true regex...
> 
>   =~ could be that.  field =~ '^spin.*{lock|unlock}$'


Ok.
I'm personnally fine with it.



> Perl is considered a much better language for regex. It has one of the
> most (if not the most) powerful regex engines. I'm sure recordmcount.pl
> would be much larger if I chose to do it in python. Same goes with
> streamline_config.pl.  They both have strong needs for complex regex.


Yeah, python was a joke. I mean I think it's a nice language
but not a syntax for what we want to do. It's an object oriented
language and I guess we don't want to do:

import re

r = re.compile("blah")
m = r.match("string")
m.group(1)
....

:-)


> > 
> > More seriously, as I said above, I think most developers are familiar with C
> > syntax, so IMHO this is one of our best possibility.
> > 
> 
> To avoid the Python vs Perl, I say we stick with sed/awk. That is also a
> requirement for most unix developers.


Yeah I'm fine with it. As long as this is something already familiar
for most users.

Let's then pick ~ for glob and ~= for regex

I'll fix that soon.

Thanks.

