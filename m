Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbZKLOcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbZKLOcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 09:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZKLOcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 09:32:05 -0500
Received: from mail-qy0-f174.google.com ([209.85.221.174]:36965 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZKLOcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 09:32:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m9Wvf4Uey11NTzkRqUsF1Ezp1zlX/eXesDu5GutTEPoJk0W/B6KsH5s+g9c+oSf0K1
         AoEIbjU6ysVPy98LxfP73BRE73PPTKN/Z//SCqsjbDIZNdhbmfXuKlC1HffXKXXt4w5m
         zgEaddPHQhl+NIlGbHGzJgmiVC1FYk6y3rgPo=
Date: Thu, 12 Nov 2009 15:32:10 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Avi Kivity <avi@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 5/7 v6] hw-breakpoints: Rewrite the hw-breakpoints
	layer on top of perf events
Message-ID: <20091112143205.GA5237@nowhere>
References: <1257694141-5670-1-git-send-email-fweisbec@gmail.com> <1257694141-5670-6-git-send-email-fweisbec@gmail.com> <4AF6FEDE.5030807@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF6FEDE.5030807@web.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 06:24:46PM +0100, Jan Kiszka wrote:
> > +	 * care about the messed up debug address registers. But if
> > +	 * we have some of them active, restore the old state.
> > +	 */
> > +	if (__get_cpu_var(dr7) & DR_GLOBAL_ENABLE_MASK)
> 
> Looks good, just a minor remark: Would be cleaner to wrap this into an
> inline function, say hw_breakpoint_active(), to abstract the precise
> condition away from KVM.


Done :)

 
> > +		hw_breakpoint_restore();
> >  
> >  	set_bit(KVM_REQ_KICK, &vcpu->requests);
> >  	local_irq_enable();
> 
> Will see that I can give your series a try the next days, probably
> debugging qemu-kvm while running a guest that uses breakpoints. But I
> don't expect surprises.
> 
> Jan


Thanks!

You can find it at:
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
	tracing/hw-breakpoints



