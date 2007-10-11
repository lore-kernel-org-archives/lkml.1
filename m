Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbXJKX0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbXJKX0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 19:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbXJKX0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 19:26:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35807 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbXJKX0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 19:26:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Paul Jackson <pj@sgi.com>
Cc: "Paul Menage" <menage@google.com>, rientjes@google.com,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       a.p.zijlstra@chello.nl, serue@us.ibm.com, clg@fr.ibm.com,
       linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com,
       xemul@openvz.org, containers@lists.osdl.org, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] task containersv11 add tasks file interface fix for cpusets
References: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
	<6599ad830710030851jb44f00ft9634f9381218b6e9@mail.gmail.com>
	<20071003105817.7adf6516.pj@sgi.com>
	<6599ad830710031110r1a74eafej56f20cc33e72ac81@mail.gmail.com>
	<20071003131632.fed4b848.pj@sgi.com>
	<6599ad830710031331h15d35e90lc63d845efd2de6f5@mail.gmail.com>
	<20071006012437.c0fd3a8a.pj@sgi.com>
	<alpine.DEB.0.9999.0710061047400.24311@chino.kir.corp.google.com>
	<20071006125904.a26ed99f.pj@sgi.com>
	<6599ad830710061409p2dcaa1c8u8c6864beaaafb149@mail.gmail.com>
	<20071011150315.78c4f45f.pj@sgi.com>
Date: Thu, 11 Oct 2007 17:20:43 -0600
In-Reply-To: <20071011150315.78c4f45f.pj@sgi.com> (Paul Jackson's message of
	"Thu, 11 Oct 2007 15:03:15 -0700")
Message-ID: <m13awhb5mc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Stupid question.

Would it help at all if we structured this as:
- Take the control group off of the cpus and runqueues.
- Modify the tasks in the control group.
- Place the control group back on the runqueues.

Essentially this is what ptrace does (except for one task at a time).

Since we know that the tasks are not running, and that we have
exclusive access to the tasks in the control group we can take action
as if we were the actual tasks themselves.  Which should simplify
locking.

So I think with just a touch of care we can significantly simplify the
locking by being much more coarse grained, at the expense of this kind
of control group operation being more expensive.  Plus we would have
an operation that was reusable.

I think the stop everything.  modify everything, start everything
could also be used instead of an array of task structures.

Eric
