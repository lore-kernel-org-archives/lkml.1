Return-Path: <linux-kernel-owner+w=401wt.eu-S1759740AbYEGS2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740AbYEGS2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 14:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765684AbYEGS1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 14:27:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765614AbYEGS1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 14:27:43 -0400
Date: Wed, 7 May 2008 11:27:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080507181714.GA14980@elte.hu>
Message-ID: <alpine.LFD.1.10.0805071125090.3024@woody.linux-foundation.org>
References: <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080507163811.GY19219@parisc-linux.org> <alpine.LFD.1.10.0805070948250.3024@woody.linux-foundation.org>
 <alpine.LFD.1.10.0805070956060.3024@woody.linux-foundation.org> <20080507172246.GA13262@elte.hu> <alpine.LFD.1.10.0805071028400.3024@woody.linux-foundation.org> <20080507174900.GB13591@elte.hu> <alpine.LFD.1.10.0805071057280.3024@woody.linux-foundation.org>
 <20080507181714.GA14980@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Ingo Molnar wrote:
> 
> [ this patch should in fact be a bit worse, because there's two more 
>   atomics in the fastpath - the fastpath atomics of the old semaphore 
>   code. ]

Well, it doesn't have the irq stuff, which is also pretty costly. Also, it 
doesn't nest the accesses the same way (with the counts being *inside* the 
spinlock and serialized against each other), so I'm not 100% sure you'd 
get the same behaviour.

But yes, it certainly has the potential to show the same slowdown. But 
it's not a very good patch, since not showing it doesn't really prove 
much.

			Linus
