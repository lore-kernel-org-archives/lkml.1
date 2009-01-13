Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbZAMJSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbZAMJSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbZAMJRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:17:46 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:53313 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574AbZAMJRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:17:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kNJ9Yb+h0nt8oEWoWCXoRcV9X4SGNth9WhltfrXhalCdLtNzh4F3r0RQJPrGH/w6Rb
         rgJuRqPkVBZimp7nlSP/Ma8epd7zscuvJOW3VPGJgfxXFSg0SNTJEgjUHSIKCcq8TBWt
         A+OIthLBWIZqw7iQilXp9n4Yenkd3arRDSGqk=
Date: Tue, 13 Jan 2009 10:17:39 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] rcu: convert rcupreempt trace to seq file
Message-ID: <20090113091738.GB5837@nowhere>
References: <496852DE.7080802@cn.fujitsu.com> <20090110223151.GD7061@linux.vnet.ibm.com> <20090111013940.GL12885@elte.hu> <20090111050129.GA6131@nowhere> <496C0850.8010103@cn.fujitsu.com> <20090113084905.GA5837@nowhere> <496C58C9.5080807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496C58C9.5080807@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 05:03:05PM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > On Tue, Jan 13, 2009 at 11:19:44AM +0800, Li Zefan wrote:
> >>> Indeed!
> >>>
> >>> The debugfs and seqfile handling and handled in the statistical
> >>> tracing engine.
> >>>
> >>> You just have to provide an iterator for your stat entries through two callbacks:
> >>>
> >>> _ stat_start() -> gives the first entry
> >>> _ stat_next() -> iterates over the next entry
> >>>
> >>> And an output callback
> >>>
> >>> _ stat_show() -> print one entry from your stat list
> >>>
> >>> And two optional things:
> >>>
> >>> _ stat_cmp() -> compare two entries, useful if you want your stats to be sorted
> >>> _ stat_headers() -> provide the first line in your stat file, typically to describe your columns
> >>>
> >>> The last thing you need is to give a name to your trace file.
> >>> You will retrieve it into /debugfs/tracing/trace_stat/your_file_name as a current snapshot
> >>> of your stats.
> >>>
> >>> It is currently used by the branch tracer, and by a pending patch for a new workqueue
> >>> tracer which will provide you a simple example.
> >>>
> >>> If you have any question about how to use it, don't hesitate to ask.
> >>>
> >> Hi Frederic,
> >>
> >> I've converted rcupreempt to use trace points, but I don't see much advantage to use
> >> trace stat instead of using seq_file directly.. And can you add support to allow
> >> me to provide stat_show() only ? I think it's common that the stat file has only
> >> one entry.
> >>
> >>
> >> Regards
> >> Li Zefan
> > 
> > 
> > It simplifies (I hope) a bit the seqfile.
> > The interface is very similar except that you don't need to deal
> > with debugfs stuffs, sorting, and position inside the seqfile.
> > And it unifies the stat files into a common directory instead of
> > having them grained into a mess of debugfs filesystem....
> > 
> 
> OK. It makes things easier for some cases. :)
> 
> But will trace_stat/ become a mess when there are many stat files in it ?
> 
> Does it make sense to support making subdir in trace_stat/ ?


Yes it's on my projects :-)


> > I could let it handle only stat_show when you have only one entry but that
> > would break the sense of stat_show.
> > If it's so common to have only one stat entry, perhaps I could provide a special callback
> > for that, something like stat_show_unique()...
> > 
> > Hm?
> > 
> 
> stat_show_single() ? I don't know which name is better.
> 
> Like it's common to use single_open with seq_file, I think it's needed as we add more
> stat files into trace_stat.
> 
> Regards
> Li Zefan
> 

stat_show_single() is a better name.
Yes that makes sense, I will add this callback.

Thanks.

