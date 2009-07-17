Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZGQEpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZGQEpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 00:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbZGQEpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 00:45:55 -0400
Received: from mail-qy0-f190.google.com ([209.85.221.190]:51119 "EHLO
	mail-qy0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZGQEpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 00:45:54 -0400
X-Greylist: delayed 384 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Jul 2009 00:45:54 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PlILzG+tuLeWr3G2+1ibD6Q1xAtyJPZ79Vv9q0rq5hKoNrb27Vf2TjnN4TZ6vfx9SU
         Gq2WEyFpvdcieqSgpq2AAUD5D2mDyOXumYntdpksTvMDxmQJcBbiGHzx4Ry/dJNjdh/y
         FBTDuXpZ7+duWwkTo4hs7Eo1pp/n5v7QuQhUQ=
Date: Fri, 17 Jul 2009 00:39:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function: simplify for
	__ftrace_replace_code()
Message-ID: <20090717043922.GC4977@nowhere>
References: <4A5D5B12.2050802@cn.fujitsu.com> <4A5D5BCF.4070707@cn.fujitsu.com> <20090717040528.GB4977@nowhere> <4A5FFE4F.8050407@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5FFE4F.8050407@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 12:30:07PM +0800, Li Zefan wrote:
> >> +	if (enable && !(rec->flags & FTRACE_FL_NOTRACE)) {
> >> +		if (ftrace_filtered) {
> >> +			if (rec->flags & FTRACE_FL_FILTER)
> >> +				flag = FTRACE_FL_ENABLED;
> >> +		} else
> >> +			flag = FTRACE_FL_ENABLED;
> > 
> > 
> > The above can be factorized in
> > 
> > if (!ftrace_filtered || rec->flags & FTRACE_FL_FILTER)
> > 	flag = FTRACE_FL_ENABLED
> > 
> 
> I think it's better to put the latter condition into parentheses:
> 
> if (!ftrace_filtered || (rec->flags & FTRACE_FL_FILTER))
> 	flag = FTRACE_FL_ENABLED
> 

Ok. Done.

