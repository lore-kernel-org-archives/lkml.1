Return-Path: <linux-kernel-owner+w=401wt.eu-S1030373AbXAaRWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030373AbXAaRWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030351AbXAaRWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:22:11 -0500
Received: from ns1.suse.de ([195.135.220.2]:54675 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030331AbXAaRWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:22:08 -0500
From: Andi Kleen <ak@suse.de>
To: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 4 of 4] Introduce aio system call submission and completion system calls
Date: Wed, 31 Jan 2007 18:21:59 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <p73abzzpo75.fsf@bingen.suse.de> <63FDFD68-EE2B-4BB7-B624-513243B87634@oracle.com>
In-Reply-To: <63FDFD68-EE2B-4BB7-B624-513243B87634@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311821.59579.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 January 2007 18:15, Zach Brown wrote:
> 
> On Jan 31, 2007, at 12:58 AM, Andi Kleen wrote:
> 
> > Do you have any numbers how this compares cycle wise to just doing
> > clone+syscall+exit in user space?
> 
> Not yet, no.  Release early, release often, and all that.  I'll throw  
> something together.

So what was the motivation for doing this then?  It's only point 
is to have smaller startup costs for AIO than clone+fork without
fixing the VFS code to be a state machine, right? 

I'm personally unclear if it's really less work to teach a lot of 
code in the kernel about a new thread abstraction than changing VFS.

Your patches don't look that complicated yet but you openly
admitted you waved away many of the more tricky issues (like 
signals etc.) and I bet there are yet-unknown side effects
of this too that will need more changes.

I would expect a VFS solution to be the fastest of any at least.

I'm not sure the fibrils thing will be that much faster than
a possibly somewhat fast pathed for this case clone+syscall+exit.

-Andi
