Return-Path: <linux-kernel-owner+w=401wt.eu-S1755091AbZHDOJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbZHDOJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbZHDOJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:09:23 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:35937 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbZHDOJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:09:23 -0400
Date: Tue, 4 Aug 2009 09:01:58 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090804140158.GA663@us.ibm.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com> <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com> <20090803175452.GA5481@us.ibm.com> <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com> <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com> <6599ad830908031255j68ce047x7165bfefa62ed53c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6599ad830908031255j68ce047x7165bfefa62ed53c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On Mon, Aug 3, 2009 at 12:45 PM, Serge E. Hallyn<serue@us.ibm.com> wrote:
> >
> > This is probably a stupid idea, but...  what about having zero
> > overhead at clone(), and instead, at cgroup_task_migrate(),
> > dequeue_task()ing all of the affected threads for the duration of
> > the migrate?
> 
> That doesn't sound too unreasonable, actually - it would certainly
> simplify things a fair bit. Is there a standard API for doing that?
> dequeue_task() itself doesn't really look like a public API. I guess
> that the task freezer would be one way to accomplish this?

Actually if we wanted to try to avoid -EINTRs for the tasks, which
they get with the freezer, we might want to code our own helpers
in sched.c based on dequeue_task().  Instead of interrupting ongoing
system calls, we'll want to set a flag saying if the syscall exits
(before we unset the flag) then dequeue it real quick.

> I can imagine that the set of people who'd complain about the latency
> hit when migrating with your solution would be smaller than the people
> who'd complain about the increased overhead in the normal clone case.
> 
> Paul
