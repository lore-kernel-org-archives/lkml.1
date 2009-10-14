Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbZJNSij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbZJNSij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757014AbZJNSij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:38:39 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59975 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbZJNSih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:38:37 -0400
Date: Wed, 14 Oct 2009 11:39:16 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnd Bergmann <arndbergmann@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Message-ID: <20091014183916.GA3515@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <20091013045556.GJ28435@us.ibm.com> <200910141426.35338.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910141426.35338.arnd@arndb.de>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann [arndbergmann@googlemail.com] wrote:
| On Tuesday 13 October 2009, Sukadev Bhattiprolu wrote:
| > +clone3(struct clone_struct * __user clone_args, pid_t * __user pids)
| > +
| > +       In addition to doing everything that clone() system call does,
| > +       the clone3() system call:
| > +
| > +               - allows additional clone flags (all 32 bits in the flags
| > +                 parameter to clone() are in use)
| > +
| > +               - allows user to specify a pid for the child process in its
| > +                 active and ancestor pid name spaces.
| 
| Someone (sorry, can't find the old mail) pointed out last time that
| the 'pid_t *__user tidptr' argument needs to be an independent pointer,
| in order to allow the same use patterns with CLONE_CHILD_SETTID and
| CLONE_CHILD_CLEARTID that you can do with the current clone
| implementation.

I think it was Oren Laadan.

| 
| Moving that argument from clone_struct into the argument list would
| also make this a three-argument syscall, which solves the naming problem.

How about we pull 'nr_pids' out of clone_args struct and make that
a separate parameter. It seems the odd man out and controls the pid_t
list parameter.
| 
| 	Arnd <><
