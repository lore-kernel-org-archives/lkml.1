Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbYDDRJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbYDDRJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 13:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbYDDRJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 13:09:38 -0400
Received: from [194.117.236.238] ([194.117.236.238]:47988 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758721AbYDDRJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 13:09:30 -0400
Date: Fri, 4 Apr 2008 20:06:10 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tom Zanussi <zanussi@us.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] relay: add buffer-only functionality, allowing for
 early kernel tracing
Message-ID: <20080404200610.747d02cd@linux360.ro>
In-Reply-To: <20080404164022.GA1762@Krystal>
References: <20080404183303.2e239a20@linux360.ro>
	<20080404160623.GC32126@Krystal>
	<20080404191943.2d708cbf@linux360.ro>
	<20080404164022.GA1762@Krystal>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008 12:40:22 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:
 
> Then I guess we would depend on page_alloc_init(). It's not that bad,
> but I guess the question is : do we prefer to let users specify the
> buffer size to reserve for tracing on the kernel command line (that
> would require __get_free_pages()) or do we compile-in a static buffer
> size, which can be specified in the kernel configuration. I think
> providing both could be an option : flexibility _and_ *very* early
> tracing.

I wasn't referring to the kernel's users specifying the buffer on the
command line. For example, LTTng code (I'm not familiar with it) could
allocate a buffer, by itself or using a helper function, and pass it to
relay_early_open(). Of course, it could read the command line and call
that helper function, passing the size required by the user as an
argument.

Basically, I'm saying that having relay code manage a large buffer,
allocating memory from it for each of its callers, could be very
complex. It would be easier and less complex to let each tracing
subsystem allocate memory on its own, either through a static buffer or
with __get_free_pages().

> So making this relay interface flexible enough to receive a buffer
> either reserved by __get_free_pages() or a static buffer seems like a
> good compromise. It would also have to receive the buffer size from
> the caller.

Yes, it shouldn't matter to the relay interface whether the buffer was
statically or dynamically allocated. All it needs to know is where it
starts and how long it is.

BTW, I'll resubmit a modified patch soon, as suggested by Randy Dunlap.


Eduard
