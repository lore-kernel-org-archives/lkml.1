Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbXHISBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbXHISBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 14:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXHISBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 14:01:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39799 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbXHISBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 14:01:38 -0400
Date: Thu, 9 Aug 2007 10:55:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
cc: Chris Snook <csnook@redhat.com>, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org
Subject: Re: [PATCH] make atomic_t volatile on all architectures
In-Reply-To: <46BB508B.7050601@redhat.com>
Message-ID: <alpine.LFD.0.999.0708091055080.25146@woody.linux-foundation.org>
References: <20070808230733.GA17270@shell.boston.redhat.com>
 <alpine.LFD.0.999.0708082116060.25146@woody.linux-foundation.org>
 <46BAC2BE.1090106@redhat.com> <46BB508B.7050601@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Aug 2007, Chuck Ebbert wrote:
> 
> You can use this forget() macro to make the compiler reread a variable:
> 
> #define forget(var) asm volatile ("" : "=m"(var))

No. That will also make the compiler "forget" any previous writes to it, 
so it changes behaviour.

You'd have to use "+m".

		Linus
