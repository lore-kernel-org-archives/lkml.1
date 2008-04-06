Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbYDFRdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbYDFRdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 13:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbYDFRcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 13:32:53 -0400
Received: from pne-smtpout4-sn2.hy.skanova.net ([81.228.8.154]:42416 "EHLO
	pne-smtpout4-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754880AbYDFRcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 13:32:52 -0400
Date: Sun, 6 Apr 2008 20:32:21 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, penberg@cs.helsinki.fi,
       vegard.nossum@gmail.com
Subject: Re: mmiotrace bug: recursive probe hit
Message-ID: <20080406203221.39378390@daedalus.pq.iki.fi>
In-Reply-To: <47F72C12.9020701@qumranet.com>
References: <20080309164050.2194461e@daedalus.pq.iki.fi>
	<20080328222500.21863a44@daedalus.pq.iki.fi>
	<20080330202608.054702a4@daedalus.pq.iki.fi>
	<20080404000701.70bbc1a4@daedalus.pq.iki.fi>
	<47F72C12.9020701@qumranet.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Apr 2008 10:36:50 +0300
Avi Kivity <avi@qumranet.com> wrote:

> However there is a simpler (for you) 
> solution: run the driver-to-be-reverse-engineered in a kvm guest, and 
> modify kvm userspace to log accesses to mmio regions.  This requires the 
> not-yet-merged pci passthrough support.  You can reverse engineer 
> Windows drivers with this as well.

This is a very interesting idea, I didn't know it would be possible.
I think this also is a new project and I'd be happy to let someone else
take it over. We could still use the log format and tools from
mmiotrace, at least for starters.

This puts mmiotrace in a new ligth: there's something better(?)
coming in the future. But mmiotrace is here now, and I'd still like to
see it in mainline. Within ftrace framework, mmiotrace will be very
easy to use even for a Linux newbie. The KVM approach would be targeted
to developers, as I suspect setting it up (even when everything has been
merged into mainline) is more work than running mmiotrace.

Ingo, what do you think? In my opinion let's make mmiotrace force the
system down to UP via CPU hotplugging while MMIO tracing is active.
This should guarantee reliable traces in the easiest way possible. The
current workaround is not reliable on SMP. "Works enough" is what I'm
thinking of.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
