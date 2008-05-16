Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbYEPCnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbYEPCnj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 22:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYEPCnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 22:43:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbYEPCnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 22:43:18 -0400
Date: Thu, 15 May 2008 19:43:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/10] Make bsd process accounting work in pid namespaces
Message-Id: <20080515194304.31309426.akpm@linux-foundation.org>
In-Reply-To: <482C15FE.7070300@openvz.org>
References: <482C15FE.7070300@openvz.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 14:52:46 +0400 Pavel Emelyanov <xemul@openvz.org> wrote:

> fter I fixed access to task->tgid in kernel/acct.c, Oleg 
> pointed out some bad side effects with this accounting vs pid 
> namespaces interaction. I.e. when some task in pid namespace 
> sets this accounting up, this blocks all the others from doing 
> the same. Restricting this to init namespace only could help, 
> but didn't look as a grace solution.
> 
> So here is the approach to make this accounting work with pid
> namespaces properly.

We still have this silliness in acct_file_reopen():

		spin_unlock(&acct_lock);
		do_acct_process(acct, old_ns, old_acct);
		filp_close(old_acct, NULL);
		spin_lock(&acct_lock);

Was this lock-dropping safe before?

Is it safe now?

To work this out, we'd need to know what acct_lock protects.  What does
acct_lock protect?
