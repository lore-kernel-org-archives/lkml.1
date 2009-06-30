Return-Path: <linux-kernel-owner+w=401wt.eu-S1757858AbZF3VZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858AbZF3VZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbZF3VZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:25:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59289 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759014AbZF3VZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:25:34 -0400
Date: Tue, 30 Jun 2009 23:25:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip 3/3] kprobes: cleanup: use list instead of hlist
	for insn_pages
Message-ID: <20090630212512.GA10831@elte.hu>
References: <20090630210757.17851.409.stgit@localhost.localdomain> <20090630210814.17851.64651.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630210814.17851.64651.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Use struct list instead of struct hlist for managing insn_pages, 
> because insn_pages doesn't use hash table.

>  struct kprobe_insn_page {
> -	struct hlist_node hlist;
> +	struct list_head list;

Hm, you know that this increases the size of kprobe_insn_page by 4/8 
bytes, right?

hlists are not just used for hashes - but also when we want a more 
compact / smaller list head.

How many kprobe_insn_page's can be allocated in the system, 
maximally?

	Ingo
