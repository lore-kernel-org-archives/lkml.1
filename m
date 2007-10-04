Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbXJDCzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbXJDCzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 22:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbXJDCzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 22:55:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50569 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752997AbXJDCzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 22:55:08 -0400
Date: Wed, 3 Oct 2007 19:55:03 -0700
From: Paul Jackson <pj@sgi.com>
To: menage@google.com
Cc: nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, clg@fr.ibm.com, ebiederm@xmission.com,
       rientjes@google.com, containers@lists.osdl.org,
       balbir@linux.vnet.ibm.com, akpm@linuxfoundation.org, xemul@openvz.org
Subject: Re: [PATCH 03/33] task containersv11 add tasks file interface
Message-Id: <20071003195503.56287e60.pj@sgi.com>
In-Reply-To: <20071003010923.c606c176.pj@sgi.com>
References: <20070917210307.116234000@menage.corp.google.com>
	<20070917210426.579524000@menage.corp.google.com>
	<20071003010923.c606c176.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more cgroup code review detail ...

The following is evidence of some more stale comments in
kernel/cpuset.c.  Some routines which used to be in that file, but
which are now reimplemented in cgroups, are still named in cpuset.c
comments:

$ grep -E 'cpuset_rmdir|cpuset_exit|cpuset_fork' kernel/cpuset.c
 * knows that the cpuset won't be removed, as cpuset_rmdir() needs
 * The fork and exit callbacks cpuset_fork() and cpuset_exit(), don't
 * critical pieces of code here.  The exception occurs on cpuset_exit(),
 *    the_top_cpuset_hack in cpuset_exit(), which sets an exiting tasks

The downside of my writing too many comments ... its more of a
maintenance burden on those changing the code ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
