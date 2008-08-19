Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYHSQuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYHSQuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 12:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYHSQun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 12:50:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753400AbYHSQum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 12:50:42 -0400
Date: Tue, 19 Aug 2008 09:48:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Fair low-latency rwlock v5
In-Reply-To: <20080819073345.GA30285@Krystal>
Message-ID: <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org>
References: <48A6EC77.8080904@zytor.com> <20080816154330.GA5880@Krystal> <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org> <20080817075335.GA25019@Krystal>
 <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org> <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, Mathieu Desnoyers wrote:
> 
> It strikes me that Intel has a nice (probably slow?) cmpxchg16b
> instruction on x86_64. Therefore, we could atomically update 128 bits,
> which gives the following table :

Stop this crapola.

Take a look at the rwsem thing I pointed you to. After you understand 
that, come back.

The WHOLE POINT of that thing was to use only 32-bit atomics on the hot 
path. Don't even start think9ing about cmpxchg16b. If you cannot do your 
atomics in 32-bit, they're broken.

Please. I realize that the rwsem implementation I did is subtle. But 
really. Spend the time to understand it.

			Linus
