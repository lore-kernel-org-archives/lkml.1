Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYK0VTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYK0VTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 16:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYK0VTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 16:19:32 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:50396 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYK0VTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 16:19:32 -0500
Subject: Re: [RFC][PATCH 2/5] pid: Generalize task_active_pid_ns
From: Greg Kurz <gkurz@fr.ibm.com>
To: Bastian Blank <bastian@waldi.eu.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, oleg@redhat.com, ebiederm@xmission.com,
       containers@lists.osdl.org, roland@redhat.com, xemul@openvz.org
In-Reply-To: <20081127011738.GC13545@wavehammer.waldi.eu.org>
References: <20081126034242.GA23120@us.ibm.com>
	 <20081126034528.GB23238@us.ibm.com>
	 <20081127011738.GC13545@wavehammer.waldi.eu.org>
Content-Type: text/plain
Date: Thu, 27 Nov 2008 22:19:25 +0100
Message-Id: <1227820765.5108.20.camel@bahia.kalilou.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 02:17 +0100, Bastian Blank wrote:
> On Tue, Nov 25, 2008 at 07:45:28PM -0800, Sukadev Bhattiprolu wrote:
> > Currently task_active_pid_ns is not safe to call after a
> > task becomes a zombie and exit_task_namespaces is called,
> > as nsproxy becomes NULL.
> 
> Why do you need to be able to get the pid namespace from zombie
> processes? Also according to nsproxy.h this access variant is only
> allowed for the current task, anything else needs to take a rcu lock.
> 

That doesn't save ->nsproxy to be NULL... as shown in the very same
example you're talking about.

I agree with Eric and Sukadev that task_active_pid_ns() is unsafe. There
isn't even a /* don't use with zombies */ in pid_namespace.h...

> >                           By reading the pid namespace from
> > the pid of the task we can trivially solve this problem at
> > the cost of one extra memory read in what should be the
> > same cacheline as we read the namespace from.
> 
> The pid namespace may not be destructed yet?
> 

Yes as long as a pid from that namespace is still in use...

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

