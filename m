Return-Path: <linux-kernel-owner+w=401wt.eu-S1752865AbYHSHTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbYHSHTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbYHSHTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:19:42 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:41520 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYHSHTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:19:42 -0400
Message-ID: <48AA73B5.7010302@linux.vnet.ibm.com>
Date: Tue, 19 Aug 2008 12:48:13 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>, Dave Hansen <haveblue@us.ibm.com>
CC: Andrea Righi <righi.andrea@gmail.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [discuss] memrlimit - potential applications that can use
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After having discussed memrlimit at the container mini-summit, I've been
investigating potential users of memrlimits. Here are the use cases that I have
so far.

1. To provide a soft landing mechanism for applications that exceed their memory
limit. Currently in the memory resource controller, we swap and on failure OOM.
2. To provide a mechanism similar to memory overcommit for control groups.
Overcommit has finer accounting, we just account for virtual address space usage.
3. Vserver will directly be able to port over on top of memrlimit (their address
space limitation feature)

The case against 1 has been that applications, do not tolerate malloc failure,
does not imply that applications should not have the capability or will never be
allowed the flexibility of doing so

Other users of memory limits I found are

1. php - through php.ini allows setting of maximum memory limit
2. Apache - supports setting of memory limits for child processes (RLimitMEM
Directive)
3. Java/KVM all take hints about the maximum memory to be used by the application
4. google.com/codesearch for RLIMIT_AS will show up a big list of applications
that use memory limits.

With this background, I propose that we need a mechanism of providing a memory
overcommit feature for cgroups, the options are

1. We keep memrlimit and use it. It's very flexible, but on the down side it
does simple total_vm based accounting and provides functionality similar to
RLIMIT_AS for control groups.
2. We port the overcommit feature (Andrea did post patches for this), it's
harder to implement, but provides functionality similar to what exists for
overcommit.


Comments?

-- 
	Warm Regards,
	Balbir
