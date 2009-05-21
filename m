Return-Path: <linux-kernel-owner+w=401wt.eu-S1755623AbZEUT5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623AbZEUT5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZEUT5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:57:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56404 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbZEUT5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:57:40 -0400
Date: Thu, 21 May 2009 21:53:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: fork() && ftrace_graph_exit_task()
Message-ID: <20090521195330.GA13604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What if the task with ->ret_stack != NULL calls fork(), and
copy_prcoess() fails after successfull dup_task_struct() ?

bad_fork_free: -> free_task()->ftrace_graph_exit_task() will
free the parent's ->ret_stack copied by arch_dup_task_struct(),
no?

Oleg.

