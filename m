Return-Path: <linux-kernel-owner+w=401wt.eu-S1753931AbZDNAYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbZDNAYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZDNAYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:24:09 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:8099 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZDNAYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nUuL40Tl6bQDzbXvpJdfj1efif2gvf6kC1bMLIkqDfs7Op0HNK3rD/rmU+dn2xOgFe
         knVFmcqGJIs7/iVsuBx7UvPCzFuhaHFqUmVMEhj3sXMPw41MOzetSqHcgYn2LH+XtdUC
         AN1vFWrkEhMxskijr43CTpBZYH00NBW8sSdcg=
Date: Tue, 14 Apr 2009 02:24:04 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
Message-ID: <20090414002403.GM5977@nowhere>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com> <20090413230110.GB817@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413230110.GB817@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 01:01:10AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> >  	TP_STRUCT__entry(
> > -		__field(const char *, name)
> > +		__array(char, name, LOCK_NAME_SIZE)
> >  		__field(unsigned long, wait_usec)
> >  		__field(unsigned long, wait_nsec_rem)
> >  	),
> 
> Hm. These constants tend to grow - 25 will certainly be too narrow. 
> But increasing it increases the record size as well.


Yeah, that's why I'm not sure about the right size.

 
> I think we'll need an embedded __string() type, with a length field 
> (but still also zero-delimited, for convenience), hm?


Indeed. It tends to be a repetitive pattern.
Also, may be we can use an undefined array size on the structure
for the __string field.
We already do so with the old style trace_printk entry and may be
some others. Extending TRACE_EVENT to support it shouldn't be a big deal.

I'll just wait for Steven changes and try to do that.


> 	Ingo

