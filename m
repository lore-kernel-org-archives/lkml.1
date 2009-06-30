Return-Path: <linux-kernel-owner+w=401wt.eu-S1760585AbZF3XUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760585AbZF3XUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760540AbZF3XSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:18:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54192 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760385AbZF3XSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:18:52 -0400
Date: Wed, 1 Jul 2009 01:18:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [PATCH -tip 3/3] kprobes: cleanup: use list instead of hlist
	for insn_pages
Message-ID: <20090630231822.GC17968@elte.hu>
References: <20090630210757.17851.409.stgit@localhost.localdomain> <20090630210814.17851.64651.stgit@localhost.localdomain> <20090630212512.GA10831@elte.hu> <4A4A8804.1040004@redhat.com> <20090630215023.GA22851@elte.hu> <4A4A9BF1.4090703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4A9BF1.4090703@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Ingo Molnar wrote:
> > * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> > 
> >> Ingo Molnar wrote:
> >>> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> >>>
> >>>> Use struct list instead of struct hlist for managing insn_pages, 
> >>>> because insn_pages doesn't use hash table.
> >>>>  struct kprobe_insn_page {
> >>>> -	struct hlist_node hlist;
> >>>> +	struct list_head list;
> >>> Hm, you know that this increases the size of kprobe_insn_page by 4/8 
> >>> bytes, right?
> >> Sure, that will increase size.
> >>
> >>> hlists are not just used for hashes - but also when we want a more 
> >>> compact / smaller list head.
> >> Oh, I thought hlists are used for hash tables...
> > 
> > ... because they are smaller, hence the hash table of list 
> > heads becomes twice as dense as with list_head.
> > 
> > But otherwise it's an (almost) equivalent primitive to list_head, 
> > with a slightly higher runtime cost versus better RAM footprint.
> > 
> >>> How many kprobe_insn_page's can be allocated in the system, 
> >>> maximally?
> >> It's depends on how many probes you will use, but logically, 1 
> >> kprobe_insn_pages is allocated per 4096/16 = 256 probes. So, if 
> >> you use 25,600 probes on your system, memory consumption will 
> >> increase 400/800 bytes.
> > 
> > it's your call really - just wanted to react on the 'because it 
> > should be used for hash tables' comment in the changelog.
> 
> Hi Ingo,
> 
> Would I might be misunderstood?
> 
> struct list_head {
>         struct list_head *next, *prev;
> };
> 
> struct hlist_node {
>         struct hlist_node *next, **pprev;
> };
> 
> Both of list_head and hlist_node are the same size...

ahhh ... a light goes up: i read it as hlist_head, while it's 
hlist_node.

You are right, hlist_node is a needless complication so your cleanup 
is correct.

	Ingo
