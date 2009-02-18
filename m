Return-Path: <linux-kernel-owner+w=401wt.eu-S1752560AbZBROCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbZBROCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 09:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZBROB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 09:01:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53522 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZBROB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 09:01:56 -0500
Date: Wed, 18 Feb 2009 15:01:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/2] tracing/function-graph-tracer: provide
	documentation for the function graph tracer
Message-ID: <20090218140150.GA31620@elte.hu>
References: <499ba227.077e420a.56d6.ffffc38b@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <499ba227.077e420a.56d6.ffffc38b@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


btw., a minor trace-output observation. We currently have this 
default output:

# tracer: function_graph
#
# CPU  DURATION                  FUNCTION CALLS
# |     |   |                     |   |   |   |

 0)               |  sys_open() {
 0)               |    do_sys_open() {
 0)               |      getname() {
 0)               |        kmem_cache_alloc() {
 0)   1.382 us    |          __might_sleep();
 0)   2.478 us    |        }

Wouldnt this tweaked version look even nicer:

#
# [ tracer: function_graph ]
#
 CPU)  <duration>   |  <function-name>
 ..............................................
   0)               |  sys_open() {
   0)               |    do_sys_open() {
   0)               |      getname() {
   0)               |        kmem_cache_alloc() {
   0)   1.382 us    |          __might_sleep();
   0)   2.478 us    |        }


Changes:

 1) Added an empty '#' line to the head. Looks nicer because 
    the comment is now symmetric.

 2) Shifted of the CPU field two positions to the left. Better 
    for paste-ability and makes the 'CPU)' header fit as well.

 3) Changed the field description in the header portion to a 
    standard <field> notation.

 4) added the '....' line to create a table.

Hm?

	Ingo
