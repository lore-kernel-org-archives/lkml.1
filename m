Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbYKNCMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbYKNCMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYKNCM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:12:27 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:33309 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751795AbYKNCM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:12:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1nSzdGpQbBb+0xrXaTNLHOl5QvFu/O5XTabx57Q8tmSbyj1aICPKrqkjmZkz028OeYhCPJOyzQWK921cJPcpmlOTVv7xinzP76gSXBvzOt82F3uHPoGxyFlfe/vXxXWkXXKEy1GaekSQmewWj/Dq0TiT4R1N9S2As7qBCZ5JHG8=  ;
X-YMail-OSG: 2vCy6iEVM1l5GDPn1gSg0AFlmgvZ40KOY28MjKyxmDsKBD61OIXQdxZKAioZQzNQjh4JgSkfXX3MaAJg9FqjOSpLwFznmy0hnRpa7qEFbXPpCo7QxzbYVeCwvmFXBTh6TdvOFk_EVbap0ZMwpDH7hKR73zcia_23ggM_KDpN
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Date: Fri, 14 Nov 2008 13:12:17 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
References: <20081104122839.GA22864@mailshack.com> <200811141211.23496.nickpiggin@yahoo.com.au> <491CD248.8030209@zytor.com>
In-Reply-To: <491CD248.8030209@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811141312.18440.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2008 12:20, H. Peter Anvin wrote:
> Nick Piggin wrote:
> > I heard from an Intel hardware engineer that Nehalem has some
> > really fancy logic in it to make locked instructions "free", that
> > was nacked from earlier CPUs because it was too costly. So obviously
> > it is taking a fair whack of transistors or power for them to do it.
> > And even then it is far from free, but still seems to be one or two
> > orders of magnitude more expensive than a regular instruction.
>
> Last I heard it was still a dozen-ish cycles even on Nehalem.

Right -- that's their definition of "free", and even comes after
they seem to have put a large amount of effort into it. So they
are still expensive.


> > IMO, we shouldn't stop bothering about LOCK prefix in the forseeable
> > future.
>
> Even if a CPU came out *today* that had zero-cost locks we'd have to
> worry about it for at least another 5-10 years.  The good news is that
> we're doing pretty good with it for now, but I don't believe in general
> we can avoid the fact that improving LOCK performance helps everything
> when you're dealing with large numbers of cores/threads.

There is a balance, though. And that is going to depend on what other
low hanging fruit the CPU has eaten, and what the ratio of lock
instructions is on the target workload. So it's always preferable to
reduce their number. (by definition they will always be more difficult
for the CPU to execute)
