Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbZJHSfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbZJHSfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932829AbZJHSfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:35:11 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:39992 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813AbZJHSfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OFPh4NWWi8HG2idakfScfAYXnZQugHbU4a/9p9ucnw7MZA2sfju2SfO+9UQXt8Ru9k
         CpVnNEXOo8ZdGADfw81+FjXTnUBZZ8BipDSDaBvSkH1GuhwqPzi0D/2MIPJodwjdhwOd
         C1RR60apYg/Ntz8GcjLw8UU1ITKgkeJcCJTEI=
Date: Thu, 8 Oct 2009 20:34:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf tools: Improve thread comm resolution in perf
	sched
Message-ID: <20091008183431.GD5073@nowhere>
References: <1255012632-7882-1-git-send-email-fweisbec@gmail.com> <1255019582.26976.314.camel@twins> <20091008171814.GC5073@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008171814.GC5073@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 07:18:16PM +0200, Frederic Weisbecker wrote:
> On Thu, Oct 08, 2009 at 06:33:02PM +0200, Peter Zijlstra wrote:
> > On Thu, 2009-10-08 at 16:37 +0200, Frederic Weisbecker wrote:
> > > When we get sched traces that involve a task that was already
> > > created before opening the event, we won't have the comm event
> > > for it.
> > 
> > pid_synthesize_comm_event() should have taken care of that..
> > 
> > > So if we can't find the comm event for a given thread, we look at the
> > > traces that may contain these informations.
> > 
> > Sure, but it would be good to find out why the synthesize bits didn't
> > work as expected.
> 
> 
> Oh you're right, I didn't notice it.
> 
> And it's weird, I've just done some tests, and I always
> have the same pids that are found inside the events but
> but not in /proc:
> 
> 7989 -> npviewer.bin
> 5467 -> xchat
> 5124 -> firefox
> 7929 -> npviewer.bin
> 
> That's weird. I'm going to look further on the proc filesystem.
> 


Geeze...this is just because we are resolving the pid, not the tid..

The patch is actually a one liner :-(



