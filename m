Return-Path: <linux-kernel-owner+w=401wt.eu-S1751447AbZINGd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbZINGd2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750891AbZINGdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:33:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZINGdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:33:25 -0400
Date: Mon, 14 Sep 2009 08:33:16 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/3] [PATCHv3 3/3] tracing - trace parser support for
	set_graph_function set_ftrace_filter set_ftrace_notrace
Message-ID: <20090914063316.GA2428@jolsa.lab.eng.brq.redhat.com>
References: <1252682969-3366-1-git-send-email-jolsa@redhat.com> <1252682969-3366-4-git-send-email-jolsa@redhat.com> <1252696810.18996.733.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252696810.18996.733.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11, 2009 at 03:20:10PM -0400, Steven Rostedt wrote:
> Nit - fix your scripts again. The subject duplicates the [PATCHv3 3/3].
oh crap, sry

> 
> On Fri, 2009-09-11 at 17:29 +0200, jolsa@redhat.com wrote:
> 
> > Fixed minor in set_graph_function display - g_show function.
> 
> > @@ -2499,7 +2456,7 @@ static int g_show(struct seq_file *m, void *v)
> >  		return 0;
> >  	}
> >  
> > -	seq_printf(m, "%pf\n", v);
> > +	seq_printf(m, "%p\n", (void *) *ptr);
> >  
> >  	return 0;
> >  }
> 
> 
> I changed this, because it has a bug itself. You just changed the way
> set_graph_function works.
> 
> It use to do:
> 
> # echo sys_open > set_graph_function
> # cat set_graph_function
> sys_open
> 
> After this change, it does
> 
> # echo sys_open > set_graph_function
> # cat set_graph_function
> ffffffff811020d0
> 
> Which is not very helpful.

holly crap on a cracker... 
I did not know vsnprintf has the %pf spec.. cool ;)

thanks,
jirka
