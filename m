Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbYHMUgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbYHMUgc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYHMUgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:36:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbYHMUgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:36:23 -0400
Message-ID: <48A3455E.20602@redhat.com>
Date: Wed, 13 Aug 2008 16:34:38 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: Efficient x86 and x86_64 NOP microbenchmarks
References: <20080813191926.GB15547@Krystal> <48A33D65.4020802@redhat.com> <48A33EE3.80109@goop.org>
In-Reply-To: <48A33EE3.80109@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a curious run of Mathieu's micro benchmark:

NR_TESTS 10000000
                       test empty cycles : 182500444
                test 2-bytes jump cycles : 195969127
                test 5-bytes jump cycles : 197000202
                    test 3/2 nops cycles : 201333408
test 5-bytes nop with long prefix cycles : 205000067
              test 5-bytes P6 nop cycles : 205000227
    test Generic 1/4 5-bytes nops cycles : 200000077
         test K7 1/4 5-bytes nops cycles : 197549045


And this was on a Pentium III 847.461 MHz box (my old toshiba laptop)

The jumps here played the best, but that could just be cache issues. But 
interesting to see that of the nops, the K7 1/4 faired the best.

-- Steve

