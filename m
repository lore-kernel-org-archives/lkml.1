Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbYFDVdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbYFDVdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbYFDVdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:33:36 -0400
Received: from smtp.innovsys.com ([66.115.232.196]:23075 "EHLO
	mail.innovsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752903AbYFDVdg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:33:36 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] sched: fix cpupri priocount
Date: Wed, 4 Jun 2008 16:35:28 -0500
Message-ID: <DCEAAC0833DD314AB0B58112AD99B93B047FE4EA@ismail.innsys.innovsys.com>
In-Reply-To: <1212613754.19205.25.camel@lappy.programming.kicks-ass.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] sched: fix cpupri priocount
Thread-Index: AcjGh3h3tncPdiF6Qnm1abqDEWg8MAAAyf9A
References: <20080604185838.5108.54912.stgit@novell1.haskins.net> <20080604190410.5108.78092.stgit@novell1.haskins.net> <1212613754.19205.25.camel@lappy.programming.kicks-ass.net>
From: "Rune Torgersen" <runet@innovsys.com>
To: "Peter Zijlstra" <peterz@infradead.org>,
       "Gregory Haskins" <ghaskins@novell.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutonix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Arnaldo Carvalho de Melo" <acme@redhat.com>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -#define CPUPRI_NR_PRI_WORDS CPUPRI_NR_PRIORITIES/BITS_PER_LONG
> > +#define CPUPRI_NR_PRI_WORDS (CPUPRI_NR_PRIORITIES + >
BITS_PER_LONG/2)/BITS_PER_LONG
> 
> (33 + 16) / 32 = 49 / 32 = 1
> 

It should not round to neares but round up....
So... #define CPUPRI_NR_PRI_WORDS (CPUPRI_NR_PRIORITIES + BITS_PER_LONG
- 1)/BITS_PER_LONG

=> (33+31)/32 = 64/32 = 2
