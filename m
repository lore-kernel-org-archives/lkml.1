Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbZFRThR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbZFRThR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 15:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbZFRThH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 15:37:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46755
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750728AbZFRThG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 15:37:06 -0400
Date: Thu, 18 Jun 2009 12:37:08 -0700 (PDT)
Message-Id: <20090618.123708.78849607.davem@davemloft.net>
To: rientjes@google.com
Cc: eric.dumazet@gmail.com, jpiszcz@lucidpixels.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0906181212380.10979@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0906180935130.2894@chino.kir.corp.google.com>
	<20090618.120034.246557840.davem@davemloft.net>
	<alpine.DEB.2.00.0906181212380.10979@chino.kir.corp.google.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Thu, 18 Jun 2009 12:23:28 -0700 (PDT)

> On Thu, 18 Jun 2009, David Miller wrote:
> 
>> > I disagree, page allocation failure messages show vital information about 
>> > the state of the VM so that we can find bugs and GFP_ATOMIC allocations 
>> > are the most common trigger for these diagnostic messages since 
>> > __GFP_WAIT allocations can trigger direct reclaim (and __GFP_FS 
>> > allocations can trigger the oom killer) to free memory and will retry the 
>> > allocation if ~__GFP_NORETRY.
>> 
>> It's COMPLETELY and ABSOLUTELY normal for GFP_ATOMIC allocations to
>> fail in the networking.
>> 
> 
> __GFP_NOWARN exists for that reason.

You're going to have to put that into every driver, every part of
the core networking, every protocol.

That's dumb.

> I understand what you're trying to avoid, but I disagree with the
> approach of altering the default behavior of GFP_ATOMIC.

The default got changed at some point because it never did
crap like this before.

> I may suggest that emitting the page allocation failures become a
> compile time option; CONFIG_DEBUG_VM would be my suggestion.

Use statistics gathering and tracing for this, not log spam.

It serves all of your needs without spewing junk into the log.  It
allows complete diagnosis and gathering of whatever information you
may need.
