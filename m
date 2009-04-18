Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbZDRQJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbZDRQJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 12:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZDRQJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 12:09:17 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:45219 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZDRQJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 12:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BiWT0ukRQhxTTyakMSDsFPBFyVFXr+4ZNZYY9K6cxVBpOZhJkT+mOxiDwbvjp3PnP3
         2THnFDNoom91SnudjtEmh5bnHqTPaOZL9Bz2Fjx2673g5BGE3Bk2qiLqMgeiXP/p7Smh
         +fza6NMZFbXjMptpiY7/knuXvobHA0et0XDHk=
Date: Sat, 18 Apr 2009 18:09:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: introduce struct ksymbol
Message-ID: <20090418160910.GA6212@nowhere>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com> <1239771791.32241.6.camel@localhost> <20090415055839.GA12040@elte.hu> <200904152021.41427.rusty@rustcorp.com.au> <1239954933.31728.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239954933.31728.12.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 12:55:33AM -0700, Joe Perches wrote:
> On Wed, 2009-04-15 at 20:21 +0930, Rusty Russell wrote: 
> > On Wed, 15 Apr 2009 03:28:39 pm Ingo Molnar wrote:
> > > Why not 'struct ksym'? That name is unused right now, it is shorter 
> > > and just as descriptive.
> > > 
> > > Regarding the change... dunno. Sam, Rusty - what do you think?
> > 
> > Yes, ksym is nice.  But agree with you that it's marginal obfuscation
> > to wrap it in a struct.
> > 
> > The current symbol printing APIs are awful; we should address them first
> > (like the %pF patch does) IMHO.
> 
> I suggest just %pS<type>
> 
> With %pS, struct ksym is probably not all that
> useful unless it's for something like a sscanf.
> 
> Today there are these symbol uses:
> name, offset, size, modname
> 
> So perhaps %pS<foo> where foo is any combination of:
> 
> n name
> o offset
> s size
> m modname
> a all
> 
> and if not specified is a name lookup ("%pSn").


Joe,

It seems to me a rather good idea, it offers a good granularity
about what has to displayed.

The only problem is the end result:

%pSnosm, %pSno, %pSosm, ...

One could end up stuck reading such a format, trying
to guess if the developer wanted to print the symbol +
"nosm" or something...

But since I don't see any point in printing nosm directly after
a symbol... :)

I like this.

Anyone? Any doubt?



> 
> 

