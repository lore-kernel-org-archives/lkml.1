Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbZGCRDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbZGCRDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 13:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbZGCRDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 13:03:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754382AbZGCRC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 13:02:59 -0400
Date: Fri, 3 Jul 2009 10:02:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, arnd@arndb.de,
       fweisbec@gmail.com, dhowells@redhat.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/urgent] x86: atomic64: Fix unclean type use
 in atomic64_xchg()
In-Reply-To: <tip-199e23780a7e75c63a9e3d1108804e3af450ea3e@git.kernel.org>
Message-ID: <alpine.LFD.2.01.0907031000590.3210@localhost.localdomain>
References: <alpine.LFD.2.01.0907021653030.3210@localhost.localdomain> <tip-199e23780a7e75c63a9e3d1108804e3af450ea3e@git.kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Jul 2009, tip-bot for Ingo Molnar wrote:
> 
> Fix atomic64_xchg() to use __atomic64_read() instead.

Hmm. The whole __atomic64_read() thing should be dropped. Are there any 
users? None of them should be valid, as Eric's numbers showed. It's 
apparently better to start out with a random value rather than actually 
trying to read it.

		Linus
