Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZD1WlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZD1WlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 18:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZD1Wkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 18:40:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37294 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbZD1Wkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 18:40:41 -0400
Date: Wed, 29 Apr 2009 00:36:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: s/parent/real_parent/ in binfmt_elf_fdpic.c
Message-ID: <20090428223619.GA12027@redhat.com>
References: <20090428223050.GA12020@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090428223050.GA12020@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, Oleg Nesterov wrote:
>
> -	prstatus->pr_ppid = task_pid_vnr(p->parent);
> +	prstatus->pr_ppid = task_pid_vnr(p->real_parent);
>  	prstatus->pr_pgrp = task_pgrp_vnr(p);

Hmm. Just noticed. What protects ->parent or ->real_parent ?

Looks like we need rcu_lock() around... The same in fs/binfmt_elf.c.
Will send another trivial patch (on top of this) tomorrow.

Oleg.

