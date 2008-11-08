Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbYKHTVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbYKHTVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbYKHTVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:21:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45162 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbYKHTVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:21:40 -0500
Date: Sat, 8 Nov 2008 11:20:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [git pull] scheduler updates
In-Reply-To: <20081108190517.GA9806@elte.hu>
Message-ID: <alpine.LFD.2.00.0811081115290.3468@nehalem.linux-foundation.org>
References: <20081108170224.GA553@elte.hu> <alpine.LFD.2.00.0811081026280.3468@nehalem.linux-foundation.org> <20081108104116.48bd26e6@infradead.org> <alpine.LFD.2.00.0811081051190.3468@nehalem.linux-foundation.org> <20081108190517.GA9806@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Nov 2008, Ingo Molnar wrote:
> 
> So that's why my change moves it from the __native_read_tsc() over to 
> _only_ the vget_cycles().

Ahh. I was looking at native_read_tscp(). Which has no barriers. But then 
we don't actually save the actual TSC, we only end up using the "p" part, 
so we don't care..

Anyway, even for the vget_cycles(), is there really any reason to have 
_two_ barriers? Also, I still think it would be a hell of a lot more 
readable and logical to put the barriers in the _caller_, so that people 
actually see what the barriers are there for.

When they are hidden, they make no sense. The helper function just has two 
insane barriers without explanation, and the caller doesn't know that the 
code is serialized wrt something random.

		Linus
