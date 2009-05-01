Return-Path: <linux-kernel-owner+w=401wt.eu-S1765122AbZEATli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765122AbZEATli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 15:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbZEATlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 15:41:11 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:51994 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756AbZEATlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 15:41:09 -0400
Date: Fri, 1 May 2009 15:31:11 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090501192142.GA18339@Krystal>
Message-ID: <alpine.DEB.1.10.0905011527260.7795@qirst.com>
References: <20090430062140.GA9559@elte.hu> <20090430063306.GA27431@Krystal> <20090430065055.GA16277@elte.hu> <alpine.DEB.1.10.0904300926530.22262@qirst.com> <20090430141211.GB5922@Krystal> <alpine.DEB.1.10.0904301009530.14178@qirst.com> <20090430194158.GB12926@Krystal>
 <alpine.DEB.1.10.0904301559500.11923@qirst.com> <20090430211750.GA19933@Krystal> <alpine.DEB.1.10.0905010939090.18324@qirst.com> <20090501192142.GA18339@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009, Mathieu Desnoyers wrote:

> What I do here is to let those u8 counters increment as free-running
> counters. Yes, they will periodically overflow the 8 bits. But I don't
> rely on this for counting the number of increments we need between
> global counter updates : I use the bitmask taken from the threshold
> value (which is now required to be a power of two) to detect 0, 1, 2, 3,
> 4, 5, 6 or 7-bit counter overflow. Therefore we can still have the kind
> of granularity currently provided. The only limitation is that we have
> to use powers of two for the threshold, so we end up counting in power
> of two modulo, which will be unaffected by the u8 overflow.

Ack. Got it. Looks good.

