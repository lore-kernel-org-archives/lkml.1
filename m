Return-Path: <linux-kernel-owner+w=401wt.eu-S1755275AbZIPIQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbZIPIQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZIPIQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:16:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbZIPIQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:16:01 -0400
Date: Wed, 16 Sep 2009 10:15:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] tracing - support multiple pids in set_pid_ftrace
	file
Message-ID: <20090916081556.GA2457@jolsa.lab.eng.brq.redhat.com>
References: <1253019893-30131-1-git-send-email-jolsa@redhat.com> <4AB038A7.2070108@cn.fujitsu.com> <1253064813.20020.171.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253064813.20020.171.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 09:33:33PM -0400, Steven Rostedt wrote:
> On Wed, 2009-09-16 at 09:00 +0800, Li Zefan wrote:
> > jolsa@redhat.com wrote:
> > > Adding the possibility to set more than 1 pid in the set_pid_ftrace file,
> > > thus allowing to trace more than 1 independent processes.
> > > 
> > > Usage:
> > > 
> > > sh-4.0# echo 284 > ./set_ftrace_pid 
> > > sh-4.0# cat ./set_ftrace_pid 
> > > 284
> > > sh-4.0# echo 1 >> ./set_ftrace_pid 
> > > sh-4.0# echo 0 >> ./set_ftrace_pid 
> > > sh-4.0# cat ./set_ftrace_pid 
> > > swapper tasks
> > > 1
> > > 284
> > > sh-4.0# echo 4 > ./set_ftrace_pid 
> > > sh-4.0# cat ./set_ftrace_pid 
> > > 4
> > > sh-4.0# echo > ./set_ftrace_pid 
> > > sh-4.0# cat ./set_ftrace_pid 
> > > no pid
> > > sh-4.0# 
> > > 
> > > 
> > > wbr,
> > > jirka
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > 
> > Looks good.
> > 
> > Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Thanks!
> 
> > 
> > a few nitpicks.
> > 
> > >  /* set when tracing only a pid */
> > 
> > This comment should be removed too.
> 
> Yeah, it goes with the deleted pointer below.
> 
> > 
> > > -struct pid *ftrace_pid_trace;
> > >  static struct pid * const ftrace_swapper_pid = &init_struct_pid;
> > >  
> > ...
> > > +static int ftrace_pid_add(int p)
> > > +{
> > > +	struct pid *pid;
> > > +	struct ftrace_pid *fpid;
> > > +	int ret = -EINVAL;
> > > +
> > > +	mutex_lock(&ftrace_lock);
> > > +
> > > +	if (!p)
> > > +		pid = ftrace_swapper_pid;
> > > +	else
> > > +		pid = find_get_pid(p);
> > > +
> > > +	if (!pid)
> > > +		goto out;
> > > +
> > > +	list_for_each_entry(fpid, &ftrace_pids, list)
> > > +		if (fpid->pid == pid)
> > > +			goto out_put;
> > 
> > rather than returning EINVAL, return EEXIST or just return 0?
> 
> I agree, return 0, if it already exists, there's no harm in it returning
> success.
> 
> -- Steve
thanks, I sent out v3

wbr,
jirka
