Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154Ab0CMJ0r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 04:26:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:50267 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950Ab0CMJ0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 04:26:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B9B5A37.2010206@s5r6.in-berlin.de>
Date: Sat, 13 Mar 2010 10:26:15 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@linux-foundation.org, sgruszka@redhat.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Document Linux's circular buffering capabilities
References: <4B9A6033.8010705@s5r6.in-berlin.de> <20100311172055.7328.51353.stgit@warthog.procyon.org.uk> <18180.1268437268@redhat.com>
In-Reply-To: <18180.1268437268@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> "...do this" could be misunderstood as "use a modulus instruction",
...
> How about:
> 
> 	Calculation of the occupancy or the remaining capacity of an
> 	arbitrarily sized circular buffer would normally be a slow operation,
> 	requiring the use of a modulus (divide) instruction.  However, if the
> 	buffer is of a power-of-2 size,
[...]

Yep.

>> I don't understand why ACCESS_ONCE is needed here.  The CIRC_SPACE and
>> CIRC_CNT macros do not look at head and tail more than once.
> 
> In this example they don't, but say someone wants to read several elements
> from the buffer, they might end up accessing their copy of head several times.

Would you agree to add a quick note that these examples are simple
enough to not strictly require ACCESS_ONCE but are meant to show what
more general code would have to do?  Else a reader might be left puzzled
why he can't see in the example code the circumstances which require
ACCESS_ONCE and may remain unsure about where to use it in his own works...

(BTW, good that I came across your documentation posting.  This twist
with possibly multiple loads was not apparent to me too.  I am going to
have to have another look at some driver code with this in mind...)
-- 
Stefan Richter
-=====-==-=- --== -==-=
http://arcgraph.de/sr/
