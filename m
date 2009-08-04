Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbZHDTTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbZHDTTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 15:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933322AbZHDTTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 15:19:23 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56318 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062AbZHDTTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 15:19:22 -0400
Date: Tue, 4 Aug 2009 14:01:39 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090804190139.GA9896@us.ibm.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com> <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com> <20090803175452.GA5481@us.ibm.com> <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com> <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com> <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com>
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
> >
> 
> Or a simpler alternative - rather than taking the thread group
> leader's rwsem in cgroup_fork(), always take current's rwsem. Then
> you're always locking a (probably?) local rwsem and minimizing the
> overhead. So not quite zero overhead in the fork path, but I'd be
> surprised if it was measurable. In cgroup_attach_proc() you then have
> to take the rwsem of every thread in the process. Kind of the
> equivalent of a per-threadgroup big-reader lock.
> 
> Paul

Yup I think that would addres my concern (cache-line bouncing in hot
clone(CLONE_THREAD) case).

thanks,
-serge
