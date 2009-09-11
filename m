Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbZIKQmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbZIKQmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZIKQmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:42:08 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54881 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbZIKQmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:42:07 -0400
Date: Fri, 11 Sep 2009 09:47:03 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       container@us.ibm.com, sukadev@us.ibm.com
Subject: Re: [RFC][v6][PATCH 0/9] clone_with_pids() syscall
Message-ID: <20090911164703.GA29169@us.ibm.com>
References: <20090910060627.GA24343@us.ibm.com> <1252668148.7126.13.camel@laptop> <200909111334.45241.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909111334.45241.arnd@arndb.de>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| Also, if you're passing a struct, why not put nr_pids in there, and
| replace clone_pid_struct with a simple array? That would give us
| 
| struct clone_struct {
|         u64 flags;
|         u64 child_stack;
|         u32 child_tid;
|         u32 parent_tid;
| 	u32 nr_pids;
| 	u32 reserved1;
| 	u64 reserved2;
| };
| 
| int clone2(struct clone_struct *cs, pid_t *pids);

My only concern with this approach was the extra copy_from_user() in the
common case (i.e when not using the extended features).  I assume the
overhead of copy_from_user() is small enough to be ignored ?

Thanks,

Sukadev
