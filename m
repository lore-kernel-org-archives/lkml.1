Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZCJLWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZCJLWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 07:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbZCJLWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 07:22:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbZCJLWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 07:22:03 -0400
Subject: Re: [PATCH 3/7] tracing: use generic __stringify
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090310105624.GD6825@nowhere>
References: <20090310045710.286915983@goodmis.org>
	 <20090310045811.084130677@goodmis.org>  <20090310105624.GD6825@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Mar 2009 12:21:17 +0100
Message-Id: <1236684077.25234.138.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 11:56 +0100, Frederic Weisbecker wrote:
> On Tue, Mar 10, 2009 at 12:57:13AM -0400, Steven Rostedt wrote:
 
> > This removes the custom made STR(x) macros in the tracer and uses
> > the generic __stringify macro instead.

> Why not simply use the # ?

> > -#define __STR(x) #x
> > -#define STR(x) __STR(x)

#include <stdio.h>

#define FOO bar

#define __STR(x) #x
#define STR(x) __STR(x)

void main(void)
{
        printf("%s %s\n", __STR(FOO), STR(FOO));
}

$ gcc -o str str.c; ./str
str.c: In function ‘main’:
str.c:9: warning: return type of ‘main’ is not ‘int’
FOO bar



