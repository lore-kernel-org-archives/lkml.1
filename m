Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbZD3Wxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbZD3Wxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764160AbZD3WxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:53:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42956 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763963AbZD3WxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:53:20 -0400
Date: Thu, 30 Apr 2009 18:53:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/7] kconfig: enable CONFIG_IKCONFIG from 
 streamline_config.pl
In-Reply-To: <9b2b86520904301451v1d77589l7ee48217fb64e567@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0904301852441.20374@gandalf.stny.rr.com>
References: <20090430185022.122124349@goodmis.org>  <20090430185219.656122641@goodmis.org> <9b2b86520904301451v1d77589l7ee48217fb64e567@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 30 Apr 2009, Alan Jenkins wrote:
> > +
> > +    if (/CONFIG_IKCONFIG/) {
> > +	if (/# CONFIG_IKCONFIG is not set/) {
> > +	    # enable IKCONFIG at least as a module
> > +	    print "CONFIG_IKCONFIG=m\n";
> > +	    # don't ask about PROC
> > +	    print "# CONFIG_IKCONFIG is not set\n";
> 
> I assume the second one should be CONFIG_IKCONFIG_PROC :-).

Ag! Thanks!

> 
> > +	} else {
> > +	    print;
> > +	}
> > +	next;
> > +    }
> > +
> > +    if (/^(CONFIG.*)=(m|y)/) {
> > +	if (defined($configs{$1})) {
> > +	    $setconfigs{$1} = $2;
> > +	    print;
> > +	} elsif ($2 eq "m") {
> > +	    print "# $1 is not set\n";
> >  	} else {
> > -		print;
> > +	    print;
> >  	}
> 
> > +    } else {
> > +	print;
> > +    }
> 
> 
> Maybe it would be cleaner make the two "if" blocks the same; i.e. do
> this instead:

Yeah, that does look cleaner.

-- Steve

> 
> +	next;
> +    }
> +
> +	print;
> 
> 
> >  }
> >  close(CIN);
> >
> 
