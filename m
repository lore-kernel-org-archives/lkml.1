Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZGVPTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZGVPTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbZGVPTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:19:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60078 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZGVPTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:19:50 -0400
Date: Wed, 22 Jul 2009 11:19:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jiri Olsa <jolsa@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing: dont reset set_ftrace_filter/notrace when opened
 with r/w perm
In-Reply-To: <20090722074230.GA18925@jolsa.lab.eng.brq.redhat.com>
Message-ID: <alpine.DEB.2.00.0907221119260.1059@gandalf.stny.rr.com>
References: <20090716165135.GA4739@jolsa.lab.eng.brq.redhat.com> <alpine.DEB.2.00.0907202104130.17909@gandalf.stny.rr.com> <20090722074230.GA18925@jolsa.lab.eng.brq.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 22 Jul 2009, Jiri Olsa wrote:

> On Mon, Jul 20, 2009 at 09:11:34PM -0400, Steven Rostedt wrote:
> > 
> > On Thu, 16 Jul 2009, Jiri Olsa wrote:
> > 
> > > If user setup set_ftrace_filter/set_ftrace_notrace files and then opens them
> > > with read&write permissions, the previous setup will be removed.
> > 
> > This is exactly what it was suppose to do.
> > 
> > man fopen:
> > 
> >        w+     Open for reading and writing.  The file is created  if  it  does
> >               not  exist, otherwise it is truncated.  The stream is positioned
> >               at the beginning of the file.
> > 
> > Which means that if you open a file for "w+" it will truncate it. Hence, 
> > you will remove all previous settings.
> > 
> > What you want is:
> > 
> >        a+     Open for reading and appending (writing at end  of  file).   The
> >               file is created if it does not exist.  The initial file position
> >               for reading is at the beginning  of  the  file,  but  output  is
> >               always appended to the end of the file.
> > 
> > Change the belowe code from "w+" to "a+" and you get your expected result.
> 
> My point was that if you open set_ftrace_filter/set_ftrace_notrace with just O_RDWR
> perm. and will use the file just for reading, the filter will reset.
> 
> You're right about the "w+", there's the O_CREAT|O_TRUNC, sry I missed that.. ;)
> Anyway with "r+" you'll get O_RDWR perm. only, showing the issue:

Ah, then the fix would be to check against O_TRUNC.

-- Steve
