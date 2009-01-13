Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbZAMNxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbZAMNxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759274AbZAMNuM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:50:12 -0500
Received: from main.gmane.org ([80.91.229.2]:47118 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734AbZAMNuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:50:04 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jan-Frode Myklebust <janfrode@tanso.net>
Subject: Re: Linux killed Kenny, bastard!
Date: Tue, 13 Jan 2009 14:41:01 +0100
Message-ID: <slrngmp6fd.24m.janfrode@lc4eb5760521341.ibm.com>
References: <20090112153304.GA19995@ioremap.net> <20090112154922.6003750b@lxorguk.ukuu.org.uk> <20090112155030.GA21063@ioremap.net> <20090112155239.5f677a17@lxorguk.ukuu.org.uk> <20090112155615.GA21350@ioremap.net> <20090112161931.6203f96e@lxorguk.ukuu.org.uk> <20090112162938.GA22647@ioremap.net> <496BCB7A.2010804@tmr.com> <20090112231728.GA23803@ioremap.net> <alpine.DEB.2.00.0901121746220.20329@chino.kir.corp.google.com> <20090113085244.GA13796@ioremap.net> <alpine.DEB.2.00.0901130134090.25386@chino.kir.corp.google.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 73.81-166-12.customer.lyse.net
User-Agent: slrn/0.9.8.1pl1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-13, David Rientjes <rientjes@google.com> wrote:
>
> When a memory-hogging task is identified, which you have complete control 
> over in userspace by tuning /proc/pid/oom_adj, it attempts to kill a child 
> first if it will allow for memory freeing without killing the parent.

So an alternative to Evgeniy Polyakov's patch would be:

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index d105eb4..5dcfc88 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -2311,10 +2311,19 @@ increase the likelihood of this process being killed by the oom-killer.  Valid
 values are in the range -16 to +15, plus the special value -17, which disables
 oom-killing altogether for this process.
 
+Child processes will inherit the parent oom_score, so to launch a potential
+rouge process that you want to be the primary target of the oom-killer, that
+can be done by adjusting the score of the parent process, before launching the
+potential rouge process. F.ex. to make sure the process "Kenny" will be a
+prime candidate to get killed:
+
+       echo 15 > /proc/self/oom_adj
+       ./Kenny
+       echo -15 > /proc/self/oom_adj
+
 2.13 /proc/<pid>/oom_score - Display current oom-killer score
 -------------------------------------------------------------
 
-------------------------------------------------------------------------------
 This file can be used to check the current score used by the oom-killer is for
 any given <pid>. Use it together with /proc/<pid>/oom_adj to tune which
 process should be killed in an out-of-memory situation.


