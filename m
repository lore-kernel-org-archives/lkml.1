Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZIKLW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZIKLW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZIKLW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:22:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33137 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbZIKLW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:22:57 -0400
Subject: Re: [RFC][v6][PATCH 0/9] clone_with_pids() syscall
From: Peter Zijlstra <peterz@infradead.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       container@us.ibm.com, sukadev@us.ibm.com
In-Reply-To: <20090910060627.GA24343@us.ibm.com>
References: <20090910060627.GA24343@us.ibm.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 13:22:28 +0200
Message-Id: <1252668148.7126.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 23:06 -0700, Sukadev Bhattiprolu wrote:

> Based on these requirements and constraints, we have been exploring a couple
> of system call interfaces and appreciate any iput.  

Why not have something like:

struct clone_struct {
	u32 size;
	u32 __reserved;
	u64 flags;
	u64 child_stack;
	u32 child_tid;
	u32 parent_tid;
};

struct clone_pid_struct {
	u32 nr;
	pid_t pids[];
};

int clone2(struct clone_struct *cs, struct clone_pid_struct *cps);

If you then get passed a longer clone_struct than you know about, all is
well IFF the tail is 0, otherwise fail with -E2BIG.

If you get passed a short clone_struct, zero out the tail.

