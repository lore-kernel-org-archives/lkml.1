Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbYHPPIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbYHPPIi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 11:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYHPPIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 11:08:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48072 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbYHPPI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 11:08:29 -0400
Message-ID: <48A6EC77.8080904@zytor.com>
Date: Sat, 16 Aug 2008 08:04:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 : support atomic ops with 64 bits integer values
References: <20080816073926.GA19546@Krystal>
In-Reply-To: <20080816073926.GA19546@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> x86_64 add/sub atomic ops does not seems to accept integer values bigger
> than 32 bits as immediates. Intel's add/sub documentation specifies they
> have to be passed as registers.

This is correct; this is in fact true for all instructions except "mov".

Whether it's sign- or zero-extending is sometimes subtle, but not in 
these cases.

Do you happen to know if this is a manifest bug in the current kernel 
(i.e. if there is anywhere we're using more than ±2 GB as a constant to 
these functions?)

Either way, I'll queue this up to tip:x86/urgent if Ingo hasn't already 
since this is a pure bug fix.

	-hpa
