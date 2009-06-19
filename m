Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbZFSUoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbZFSUoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 16:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759843AbZFSUlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 16:41:42 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43363 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759815AbZFSUll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 16:41:41 -0400
To: David Miller <davem@davemloft.net>
Cc: rientjes@google.com, eric.dumazet@gmail.com, jpiszcz@lucidpixels.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] ipv4: don't warn about skb ack allocation failures
References: <alpine.DEB.2.00.0906180935130.2894@chino.kir.corp.google.com>
	<20090618.120034.246557840.davem@davemloft.net>
	<alpine.DEB.2.00.0906181212380.10979@chino.kir.corp.google.com>
	<20090618.123708.78849607.davem@davemloft.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 19 Jun 2009 13:41:37 -0700
In-Reply-To: <20090618.123708.78849607.davem@davemloft.net> (David Miller's message of "Thu\, 18 Jun 2009 12\:37\:08 -0700 \(PDT\)")
Message-ID: <m1ljnoyn0e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: davem@davemloft.net, linux-kernel@vger.kernel.org, jpiszcz@lucidpixels.com, eric.dumazet@gmail.com, rientjes@google.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: David Rientjes <rientjes@google.com>
> Date: Thu, 18 Jun 2009 12:23:28 -0700 (PDT)
>
>> On Thu, 18 Jun 2009, David Miller wrote:
>> 
>>> > I disagree, page allocation failure messages show vital information about 
>>> > the state of the VM so that we can find bugs and GFP_ATOMIC allocations 
>>> > are the most common trigger for these diagnostic messages since 
>>> > __GFP_WAIT allocations can trigger direct reclaim (and __GFP_FS 
>>> > allocations can trigger the oom killer) to free memory and will retry the 
>>> > allocation if ~__GFP_NORETRY.
>>> 
>>> It's COMPLETELY and ABSOLUTELY normal for GFP_ATOMIC allocations to
>>> fail in the networking.
>>> 
>> 
>> __GFP_NOWARN exists for that reason.
>
> You're going to have to put that into every driver, every part of
> the core networking, every protocol.
>
> That's dumb.
>
>> I understand what you're trying to avoid, but I disagree with the
>> approach of altering the default behavior of GFP_ATOMIC.
>
> The default got changed at some point because it never did
> crap like this before.

I started seeing this about when I upgraded to 2.6.28.

>> I may suggest that emitting the page allocation failures become a
>> compile time option; CONFIG_DEBUG_VM would be my suggestion.
>
> Use statistics gathering and tracing for this, not log spam.
>
> It serves all of your needs without spewing junk into the log.  It
> allows complete diagnosis and gathering of whatever information you
> may need.

I know my logs are overloaded with this noise, even on my laptop!

But Mr. Reintjes if you really want the traces I can set up 
an script to email them to you every time it happens.  Say about
1 a minute from my paltry little farm of machines.

Eric
