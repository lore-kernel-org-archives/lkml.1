Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbYILPKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbYILPKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 11:10:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYILPKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 11:10:00 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:17907 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbYILPJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 11:09:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UeAv5unxOykFuIIrlVAcF69IDbBbnlST+KuJ+7kSG+YHUaRE+rABd5G8/LFsJ+B0bq
         r+7oShNVpLFBKZWxo7dLe6RJ1RZQm3TSzynnMfjjmkfAPzBKQhLPb0558vkoNRm5PZDC
         DoBiQU1IOaeaOQd43vHS34JOwTmUXlt1+nJ84=
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Carl Henrik Lunde <chlunde@ping.uio.no>,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       =?utf-8?q?Fernando=20Luis=20V=C3=A1zquez=20Cao?= 
	<fernando@oss.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, agk@sourceware.org,
       Marco Innocenti <m.innocenti@cineca.it>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Matt Heaton <matt@bluehost.com>,
       David Radford <dradford@bluehost.com>,
       containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH -mm 0/2] memcg: per cgroup dirty_ratio
Date: Fri, 12 Sep 2008 17:09:50 +0200
Message-Id: <1221232192-13553-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The goal of the patch is to control how much dirty file pages a cgroup can have
at any given time (see also [1]).

Dirty file and writeback pages are accounted for each cgroup using the memory
controller statistics. Moreover, the dirty_ratio parameter is added to the
memory controller. It contains, as a percentage of the cgroup memory, the
number of dirty pages at which the processes belonging to the cgroup which are
generating disk writes will start writing out dirty data.

So, the behaviour is actually the same as the global dirty_ratio, except that
it works per cgroup.

Interface:
- two new entries "writeback" and "filedirty" are added to the file
  memory.stat, to export to userspace respectively the number of pages under
  writeback and the number of dirty file pages in the cgroup

- the new file memory.dirty_ratio is added in the cgroup filesystem to show/set
  the memcg dirty_ratio

[ This patch is still experimental and I only did few quick tests. I'd like to
do run more detailed benchmarks and compare the results, I guess the overhead
introduced by this patch shouldn't be so small... and BTW I would prefer a
dirty limit in bytes, intead of using a percentage of memory. Bytes are hugely
more flexible IMHO, they allow to define more fine-grained limits and so this
would work better on large memory machines. ]

[1] http://lkml.org/lkml/2008/9/9/245

-Andrea
