Return-Path: <linux-kernel-owner+w=401wt.eu-S2992858AbXCCBSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992858AbXCCBSZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992864AbXCCBSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:18:25 -0500
Received: from warden-p.diginsite.com ([208.29.163.248]:56663 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S2992858AbXCCBSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:18:24 -0500
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Mar 2007 20:18:24 EST
Date: Fri, 2 Mar 2007 16:53:41 -0800 (PST)
From: David Lang <dlang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: linux-kernel@vger.kernel.org
Subject: dynamic linking files slow fork down significantly
Message-ID: <Pine.LNX.4.63.0703021647070.24792@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a fork-heavy workload (a proxy that forks per connection, I know it's not 
the most efficiant design) and I discovered a 2x performance difference between 
a static and dynamicly linked version of the same program (2200 connections/sec 
vs 4700 connections/sec)

I know that there is overhead on program startup, but didn't expect to find it 
on a fork with no exec. If I has been asked I would have guessed that the static 
version would have been slower due to the need to mark more memory as COW.

what is it that costs so much with dynamic libraries on a fork/clone?

according to strace, the clone call that's being made is
clone(child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, 
child_tidptr=0xb7c92c08)

David Lang
