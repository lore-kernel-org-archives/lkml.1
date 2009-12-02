Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZLBEYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZLBEYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755124AbZLBEYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:24:09 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33852 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbZLBEYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:24:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MmeofUN0mZeFbpQpgrFH0hQhCZLbGoOWZBikfiItCa8mCRhMy2Fybd/oEw9TCTGnw7
         A7Sjs2Cf72PUOG1wZTFqpFaGhqa8nQ9OS6OEPsC3yTcKnMrXCMUnSPbPFd9EavstESuH
         w5FYUM6l1pc8PW+v6LRKo+Qn5LRWNvxcZBA+Y=
Date: Wed, 2 Dec 2009 05:24:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] trace_syscalls: Remove unused
	event_syscall_enter and event_syscall_exit
Message-ID: <20091202042411.GA5428@nowhere>
References: <4B14D278.4090209@cn.fujitsu.com> <tip-bf56a4ea9f1683c5b223fd3a5dbea23f1fa91c34@git.kernel.org> <20091201175403.GC5080@nowhere> <4B15BF4E.2000606@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B15BF4E.2000606@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 09:13:50AM +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> 
> > 
> > Except for this patch. The whole series is really nice, thanks
> > a lot for this cleanup!
> > 
> > 
> > 
> 
> > But I think you fixed it the wrong way.
> > 
> > Why do we need a copy of this event_syscall_enter
> > for each syscall event?
> > Can't we actually drop enter_syscall_print_##sname
> > and always use event_syscall_enter instead?
> > 
> > The same applies to exit syscall events.
> > 
> > Thanks.
> > 
> 
> 64c12e0444fcc6b75eb49144ba46d43dbdc6bc8f is a nice patch from
> Jason Baron, this patch introduces enter_syscall_print_##sname.
> 
> This patch only forgot to do some cleanups. My patch make up it:
> 
> fix event_enter_##sname->event
> fix event_exit_##sname->event
> 
> remove unused event_syscall_enter and event_syscall_exit
> 
> Thanks,
> Lai


Ah right I forgot about this. We need different enter_syscall_print_##sname
so that we can have different event ids for each syscalls.

Ok, fine then, thanks :)

