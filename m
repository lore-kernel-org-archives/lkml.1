Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0BLDCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 22:02:13 -0500
Received: from ozlabs.org ([203.10.76.45]:57890 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850Ab0BLDCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 22:02:11 -0500
Date: Fri, 12 Feb 2010 14:02:05 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       Dave Wootton <dwootton@us.ibm.com>
Subject: Why is PERF_FORMAT_GROUP incompatible with inherited events?
Message-ID: <20100212030205.GE13769@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently have this code in perf_event_alloc() in kernel/perf_event.c:

	/*
	 * we currently do not support PERF_FORMAT_GROUP on inherited events
	 */
	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
		goto done;

plus there is a comment "XXX PERF_FORMAT_GROUP vs inherited events
seems difficult" next to perf_output_read_group() (but there isn't a
similar comment on perf_read_hw()).

First, what is the difficulty referred to here?

Secondly, if the difficulty is just to do with the intersection of
sampling counters, inheritance, and group readout (as seems to be the
case), could we please allow group readout on ordinary counting
(non-sampling) counters?  That is, change the test above to something
like:

	if (attr->inherit && attr->sample_period &&
	    (attr->read_format & PERF_FORMAT_GROUP))
		goto done;

Any objections to that change?  If it's OK, could we get it into .33
and .32-stable?

Paul.
