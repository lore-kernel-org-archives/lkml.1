Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbZDUV3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbZDUV3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758023AbZDUV3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:29:11 -0400
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:47048 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757974AbZDUV3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:29:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=elastic.org;
	h=Received:Received:Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	b=gA+2JxQpzNXpbP50BvZiEH0oDf7Zdl5VVRsP3XLAVrbsDaNxoTuiysdpuaI943UmA1i1IpEEk2Easyt85vj1Mra5iKUJbR+G9X0KIhOv6Uo0nNwQTEMvBa6lkh9JYF74;
Date: Tue, 21 Apr 2009 17:23:47 -0400
From: "Frank Ch. Eigler" <fche@elastic.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Jiaying Zhang <jiayingz@google.com>,
       Michael Rubin <mrubin@google.com>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Pekka@firstfloor.org
Subject: Re: [PATCH 2/8] tracing: create automated trace defines
Message-ID: <20090421212347.GC402@elastic.org>
References: <49E6065B.7080409@goop.org> <20090416023456.GC22378@Krystal> <49E69E76.9030608@goop.org> <20090416234410.GA20513@Krystal> <87zlebpzmk.fsf@basil.nowhere.org> <20090421155106.GE3792@Krystal> <49EDFFE6.1080401@goop.org> <alpine.DEB.2.00.0904211320440.10097@gandalf.stny.rr.com> <20090421202828.GB32179@basil> <alpine.DEB.2.00.0904211711260.10097@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904211711260.10097@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Tue, Apr 21, 2009 at 05:17:17PM -0400, Steven Rostedt wrote:

> [...]  Perhaps we should fork off gcc and ship Linux with its own
> compiler. This way we can optimize it for the kernel and not worry
> about any userland optimizations.

In this regard, kernel land does not seem that unlike user land.

> 	if (unlikely(err)) {
> 		__section__(".error_sect") {
> 			/* put error code here */
> 		}
> 	}
> 
> And have gcc in the error section (if it is big enough perhaps) do:
> 	jmp .L123
> .L124   [...]
> [...]
> 	jmp .L124

> We could do the same for trace points. That is, any part of code that 
> really would happen once in a while (error handling for one) we can move 
> off to its own section and keep hot paths hot.

This is called -freorder-blocks or -freorder-blocks-and-partition
(depending on how far you would like gcc to move unlikely blocks).

- FChE
