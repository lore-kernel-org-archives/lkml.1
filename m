Return-Path: <linux-kernel-owner+w=401wt.eu-S1766995AbXDEOGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766995AbXDEOGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766992AbXDEOGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:06:35 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:38236 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766995AbXDEOGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:06:33 -0400
Date: Thu, 5 Apr 2007 19:43:21 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       winget@google.com, containers@lists.osdl.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Message-ID: <20070405141321.GH28414@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <6599ad830704032104hda0c4bu7099c23a86940c76@mail.gmail.com> <20070404051526.GA16562@in.ibm.com> <6599ad830704040000of7f1197ica543e14d290509e@mail.gmail.com> <20070404172643.GA28328@in.ibm.com> <6599ad830704041957y7b81c4ecrd21f4c08b9d7c72d@mail.gmail.com> <20070405063950.GA3435@in.ibm.com> <6599ad830704042348q5675c01ep92679fb3275bafac@mail.gmail.com> <20070405084920.GB20356@in.ibm.com> <6599ad830704050229q1d4d1ef9ved0e58b93aef31ff@mail.gmail.com> <20070405124325.GA13822@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405124325.GA13822@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 06:13:25PM +0530, Srivatsa Vaddagiri wrote:
> Lets go back to the f_bc example here for a moment. Lets say T1 was in C1 and 
> opened file f1. f1->f_bc points to C1->beancounter.
> 
> T1 moves from C1 -> C2, but f1 is not migrated. 
> C1->beancounter.count stays at 1 (to account for f1->f_bc).

Actually C1->beancounter.count should be at 2 (C1->beancounter and
f1->f_bc are pointing to it).

> File f1 is closed. C1->beancounter.count becomes zero.

C1->beancounter.count should go to 1 ..

> Now user issues rmdir C1. If rmdir finds (after taking manage_mutex that
> is)
> 
> 	- zero tasks in C1
> 	- zero refcount in C1->beancounter

s/zero refcount in C1->beancounter/exactly 1 refcount in C1->beancounter

> why is it not safe to assume that C1->beancounter.count will continue to
> stay zero?

s/zero/at one

> Basically I am struggling to answer "How can a zero refcount (beancounter) 
> object go non-zero when zero tasks are attached to it" ..

s/zero/one and s/non-zero/>1

Essentially bc_subsys->can_attach(struct bean_counter *b) can return
-EBUSY if (atomic_read(&b->count) > 1) ..

-- 
Regards,
vatsa
