Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZHUKja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZHUKja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 06:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZHUKj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 06:39:29 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:48895 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZHUKj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 06:39:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mxmBufUfvDESesFm4u64CmMODlHIB+iolJFg2tafiSWL7smTBU+mPG43GwkW1A6yCX
         V45V1fEj3iaWq9++dE6+9+WuZzkFG8iorvWr6mfUJiShOAZfPJ0GiUYsNy9okq4zMgZC
         HFepY1ojmUAUrBvyKos9voKG6IOBWuceEBbO0=
Date: Fri, 21 Aug 2009 18:38:57 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-20-19-18 uploaded
Message-ID: <20090821103813.GA27473@darkstar>
References: <200908210222.n7L2Musb015815@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908210222.n7L2Musb015815@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi andrew

cgroup build fail:

kernel/sched.c:10452: error: expected ';', ',' or ')' before 'bool'
kernel/sched.c:10536: error: 'cpu_cgroup_attach' undeclared here (not in a function)
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2
make: *** Waiting for unfinished jobs....

fixing:
--

--- linux-2.6.orig/kernel/sched.c	2009-08-21 18:08:16.000000000 +0800
+++ linux-2.6/kernel/sched.c	2009-08-21 18:20:03.000000000 +0800
@@ -10448,7 +10448,7 @@ cpu_cgroup_can_attach(struct cgroup_subs
 
 static void
 cpu_cgroup_attach(struct cgroup_subsys *ss, struct cgroup *cgrp,
-		  struct cgroup *old_cont, struct task_struct *tsk
+		  struct cgroup *old_cont, struct task_struct *tsk,
 		  bool threadgroup)
 {
 	sched_move_task(tsk);
