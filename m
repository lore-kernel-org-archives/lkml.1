Return-Path: <linux-kernel-owner+w=401wt.eu-S966837AbXHIRmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966837AbXHIRmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965187AbXHIRmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:42:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965112AbXHIRmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:42:21 -0400
Message-ID: <46BB508B.7050601@redhat.com>
Date: Thu, 09 Aug 2007 13:36:11 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       ak@suse.de, heiko.carstens@de.ibm.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org
Subject: Re: [PATCH] make atomic_t volatile on all architectures
References: <20070808230733.GA17270@shell.boston.redhat.com> <alpine.LFD.0.999.0708082116060.25146@woody.linux-foundation.org> <46BAC2BE.1090106@redhat.com>
In-Reply-To: <46BAC2BE.1090106@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2007 03:31 AM, Chris Snook wrote:
> 
> Fair enough.  Casting to (volatile int *) will give us the behavior
> people expect when using atomic_t without needing to use inefficient
> barriers.
> 

You can use this forget() macro to make the compiler reread a variable:

#define forget(var) asm volatile ("" : "=m"(var))
