Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbZCWIeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbZCWIeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbZCWIdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:33:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55155 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758118AbZCWIdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:33:41 -0400
Date: Mon, 23 Mar 2009 09:33:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tracing/filters: use list_for_each_entry_safe
Message-ID: <20090323083333.GD18837@elte.hu>
References: <1237796788.7527.35.camel@charm-linux> <49C748B0.20305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C748B0.20305@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> > -	list_for_each_safe(entry, tmp, &call->fields) {
> > -		field = list_entry(entry, struct ftrace_event_field, link);
> > +	list_for_each_entry_safe(field, next, &call->fields, link) {
> 
> Why we need _safe version ?

indeed the plain list_for_each_entry() variant would be fine, as the 
list is only walked, not modified:

> >  		if (!strcmp(field->name, name))
> >  			return field;
> >  	}

(I've applied this patch already as it was a step forward - so 
please enhance this in the next round of cleanups via a delta patch 
- thanks!)

	Ingo
