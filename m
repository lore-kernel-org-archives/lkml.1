Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbXKTWzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbXKTWzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbXKTWzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:55:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbXKTWzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:55:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: 2.6.24-rc3: find complains about /proc/net
In-Reply-To: Ingo Molnar's message of  Tuesday, 20 November 2007 23:35:59 +0100 <20071120223559.GA6655@elte.hu>
References: <20071119191000.GA1560@elf.ucw.cz>
	<200711192304.25087.rjw@sisk.pl>
	<4743026B.2020907@openvz.org>
	<m11wakshyz.fsf@ebiederm.dsl.xmission.com>
	<20071120215914.GE24156@elte.hu>
	<m1ve7wr28z.fsf@ebiederm.dsl.xmission.com>
	<20071120223559.GA6655@elte.hu>
X-Zippy-Says: When this load is DONE I think I'll wash it AGAIN..
Message-Id: <20071120225457.B6E2D26F8BE@magilla.localdomain>
Date: Tue, 20 Nov 2007 14:54:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When did /proc/self get changed to follow tgid instead of pid?  glibc uses
/proc/self to refer to various things that are usually shared anyway (fd,
maps, cwd, exe), but I think the expectation has always been that this
refers to the same calling thread, not the group leader.  e.g., if one
thread has changed uids so it no longer has access to the group leader's
/proc/PID/fd, suddenly it using /proc/self/fd starts failing.


Thanks,
Roland
