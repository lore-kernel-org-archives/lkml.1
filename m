Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbZLRVaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbZLRVaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932735AbZLRVaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:30:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:35620 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717AbZLRVaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:30:14 -0500
Subject: Re: [PATCH 1/1] perf record: We should fork only if a program was
 specified to run
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20091218205853.GD19708@ghostprotocols.net>
References: <1261168944-6615-1-git-send-email-acme@infradead.org>
	 <1261169561.20899.630.camel@laptop>
	 <20091218205853.GD19708@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Dec 2009 22:29:50 +0100
Message-ID: <1261171790.20899.675.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 18:58 -0200, Arnaldo Carvalho de Melo wrote:
> > > -   if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
> > > +   if (target_pid == -1 && argc > 0 &&
> > > +       (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
> > >             perror("failed to create pipes");
> > >             exit(-1);
> > >     }

Also, there's an unconditional close() a bit further down.

If not for that, I'd have put the whole mkpipe thing in the if
(target_pid == -1) branch.

Maybe I shouldn't have skimped on the extra state for that close

