Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYKMN7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYKMN7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 08:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYKMN72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 08:59:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44890 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYKMN71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 08:59:27 -0500
Date: Thu, 13 Nov 2008 08:59:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Pekka Paalanen <pq@iki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 1/1] ftrace: do not update max buffer with no users
In-Reply-To: <alpine.DEB.1.10.0811130848450.7458@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0811130856451.7458@gandalf.stny.rr.com>
References: <20081113043449.751885305@goodmis.org> <20081113043751.796120007@goodmis.org> <20081113084040.GD25479@elte.hu> <alpine.DEB.1.10.0811130752480.7458@gandalf.stny.rr.com> <20081113131939.GA2669@elte.hu>
 <alpine.DEB.1.10.0811130848450.7458@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 13 Nov 2008, Steven Rostedt wrote:

> Right now I'm thinking my other suggestion is the best. Just allocate the 
> max_tr.buffer and get rid of the CONFIG. This solution is very small, and 
> covers all corner cases.

And for 29, we can change the code so that the max_tr buffer is only 
allocated by request of a tracer at plugin time. In which we can do tests 
if the max_tr.buffer exists in the use cases, and warn if it does not (a 
plugin needs to request a max_tr buffer before using update_max_tr).

-- Steve

