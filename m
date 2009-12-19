Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbZLSV6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbZLSV6o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 16:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZLSV6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 16:58:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:47721 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbZLSV6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 16:58:43 -0500
Date: Sat, 19 Dec 2009 19:58:34 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1 v2] perf record: We should fork only if a program
	was specified to run
Message-ID: <20091219215834.GE19708@ghostprotocols.net>
References: <1261257771-10263-1-git-send-email-acme@infradead.org> <1261258741.4314.0.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261258741.4314.0.camel@laptop>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Dec 19, 2009 at 10:39:01PM +0100, Peter Zijlstra escreveu:
> On Sat, 2009-12-19 at 19:22 -0200, Arnaldo Carvalho de Melo wrote:
> > @@ -550,7 +551,7 @@ static int __cmd_record(int argc __used, const char **argv)
> >                         return err;
> >         }
> >  
> > -       if (!system_wide)
> > +       if (!system_wide && profile_cpu == -1)
> >                 event__synthesize_thread(pid, process_synthesized_event,
> >                                          session); 
> 
> Not actually sure about this bit though, since we now have
> per-task-per-cpu things, the profile_cpu is also used to !system_wide.

this actually means: if it is not system wide and not for an specific
cpu, it must be for an specific pid.

Not clear, right, you may want to profile an specific pid but only when
it is running on an specific CPU... But at least this patch allows for
specifiying either an specific CPU or an specific pid or systemwide.

- Arnaldo
