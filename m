Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbYHVR6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbYHVR6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 13:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYHVR5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 13:57:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41923 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbYHVR5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:57:46 -0400
Message-ID: <48AEFDF6.7020504@zytor.com>
Date: Fri, 22 Aug 2008 10:57:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
References: <20080820162925.75a5e064@doriath.conectiva> <48ADDF4F.2020401@zytor.com> <48AE5FCF.6030103@zytor.com> <20080822065012.GV14110@elte.hu> <20080822113941.147a1db0@doriath.conectiva> <20080822153451.GA8390@Krystal> <20080822132948.57e47076@doriath.conectiva> <48AEF457.5020100@zytor.com> <20080822174529.GA13020@Krystal>
In-Reply-To: <20080822174529.GA13020@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> 
> The patch which turns on this bug this this important change to the
> apply paravirt : it disables interrupts _near_ the code patching,
> _within_ the loop. Before, interrupts were disabled outside of the loop.
> It needs to disable interrupts within the loop to be able to use vmap in
> text_poke().
> 
> So I bet VirtualBox has a race in the way it handles interrupt
> disabling.
> 

That seems a bit far-fetched.  The fault is in an initcall, and there 
are no interrupts involved.  Perhaps VirtualBox doesn't manage its 
tcache correctly, but I don't see this as being interrupt-related.

	-hpa
