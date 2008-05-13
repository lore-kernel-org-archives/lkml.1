Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYEMNT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYEMNT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 09:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbYEMNTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:19:48 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:34473 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbYEMNTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:19:47 -0400
Subject: Re: System call audit
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <20080513131207.GA32306@Krystal>
References: <20080513000617.GA26009@Krystal>
	 <1210670669.3582.219.camel@pmac.infradead.org>
	 <20080513125120.GB29334@Krystal>
	 <1210683590.3582.242.camel@pmac.infradead.org>
	 <20080513131207.GA32306@Krystal>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 13 May 2008 09:19:07 -0400
Message-Id: <1210684747.6206.108.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-13 at 09:12 -0400, Mathieu Desnoyers wrote:
> * David Woodhouse (dwmw2@infradead.org) wrote:
> > On Tue, 2008-05-13 at 08:51 -0400, Mathieu Desnoyers wrote:
> > > * David Woodhouse (dwmw2@infradead.org) wrote:
> > > > On Mon, 2008-05-12 at 20:06 -0400, Mathieu Desnoyers wrote:
> > > > > Hi David,
> > > > > 
> > > > > As I am looking into the system-wide system call tracing problem, I
> > > > > start to wonder how auditsc deals with the fact that user-space could
> > > > > concurrently change the content referred to by the __user pointers.
> > > > 
> > > > In general we have to copy the content into kernel space, audit it, and
> > > > then act on it from there. See the explanation on the IPC audit patch at
> > > > http://lwn.net/Articles/125350/ for example.
> > > > 
> > > > Auditing one thing and then acting on another would be simply broken.
> > > > 
> > > > > This would be the case for execve. If we create a program with two
> > > > > thread; one is executing execve syscalls and the other thread would be
> > > > > modifying the userspace string containing the name of the program to
> > > > > execute.
> > > > 
> > > > I was going to suggest that that attack vector won't work, because
> > > > execve() kills all threads. But all you have to do to avoid that is put
> > > > the data in question into a shared writable mmap and modify it from
> > > > another _process_. And in fact I suspect there's a combination of CLONE_
> > > > flags which would avoid the thread-killing behaviour anyway.
> > > > 
> > > 
> > > Even better : if execve fails, it doesn't kill the threads. Therefore,
> > > all we have to do is to busy-loop doing failing execve() calls and
> > > atomically change the string to what we want to be executed. Can anyone
> > > test the sample snippet in a context where executing /bin/bash is
> > > disallowed on a SMP system ? I don't have a selinux setup handy. 
> > 
> > You were talking about audit earlier. Now you seem to be talking about
> > selinux. 
> > 
> 
> I thought selinux did hook into syscall audit ? (sorry, I am new to the
> kernel auditing field) The race I refer to is in the auditsc.c kernel
> code, so syscall audit would be the one I am talking about. I refer to
> selinux here just because, as of my understanding, it happens to be one
> module-based callback which can hook on syscall audit.

SELinux is a user of the audit subsystem in terms of generating audit
messages for permission denials.  It doesn't rely on any inputs from the
audit subsystem.

-- 
Stephen Smalley
National Security Agency

