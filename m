Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbXJCRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbXJCRwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbXJCRwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:52:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51864 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753603AbXJCRwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:52:03 -0400
Date: Wed, 3 Oct 2007 10:51:57 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, serue@us.ibm.com,
       clg@fr.ibm.com, ebiederm@xmission.com, xemul@openvz.org,
       rientjes@google.com, svaidy@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       a.p.zijlstra@chello.nl, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/33] task containersv11 add tasks file interface
Message-Id: <20071003105157.254c51a4.pj@sgi.com>
In-Reply-To: <6599ad830710030816m32321b54gbc79c24d0a39941b@mail.gmail.com>
References: <20070917210307.116234000@menage.corp.google.com>
	<20070917210426.579524000@menage.corp.google.com>
	<20071003010923.c606c176.pj@sgi.com>
	<6599ad830710030816m32321b54gbc79c24d0a39941b@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> Are there cases when userspace is
> required to try to reattach a task to its current cpuset in order to
> get a cpu mask change to stick?

Yes, there are such cases.

If tasks are running in a cpuset, and someone changes the
'cpus' of that cpuset, the tasks already in that cpuset don't
move.  They stay with their task structs cpus_allowed pointing
to the old value.  The only code path that user space can trigger
that leads to changing an existing tasks cpus_allowed mask is to
write that tasks pid to a cpuset 'tasks' file.

So after changing the 'cpus' of a cpuset, you (something in
user space) then has to rewrite every pid in that cpusets
tasks file back to that same tasks file, in order to get the
change to be applied to each of those tasks, and get them to
start running on their new CPUs.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
