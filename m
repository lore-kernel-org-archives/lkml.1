Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZILROf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZILROf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 13:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZILROb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 13:14:31 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48310 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbZILROb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 13:14:31 -0400
Date: Sat, 12 Sep 2009 10:19:30 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       container@us.ibm.com, sukadev@us.ibm.com
Subject: Re: [RFC][v6][PATCH 0/9] clone_with_pids() syscall
Message-ID: <20090912171930.GB29169@us.ibm.com>
References: <20090910060627.GA24343@us.ibm.com> <1252668148.7126.13.camel@laptop> <200909111334.45241.arnd@arndb.de> <20090911164703.GA29169@us.ibm.com> <1252688404.7126.40.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252688404.7126.40.camel@laptop>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra [peterz@infradead.org] wrote:
| On Fri, 2009-09-11 at 09:47 -0700, Sukadev Bhattiprolu wrote:
| > | Also, if you're passing a struct, why not put nr_pids in there, and
| > | replace clone_pid_struct with a simple array? That would give us
| > | 
| > | struct clone_struct {
| > |         u64 flags;
| > |         u64 child_stack;
| > |         u32 child_tid;
| > |         u32 parent_tid;

BTW, these two tids are __user pointers that kernel copies data into.
They should be u64 to avoid conversions in architecture specific code ?

| > | 	u32 nr_pids;
| > | 	u32 reserved1;
| > | 	u64 reserved2;
| > | };
| > | 
| > | int clone2(struct clone_struct *cs, pid_t *pids);
| > 
| > My only concern with this approach was the extra copy_from_user() in the
| > common case (i.e when not using the extended features).  I assume the
| > overhead of copy_from_user() is small enough to be ignored ?
| 
| I would think so, esp for small structure, it would be a cache hot copy.
| That is, for x86 I doubt it'll show up. No idea what hoops other arch
| have to jump through to get copy_from_user() doing what it does.
