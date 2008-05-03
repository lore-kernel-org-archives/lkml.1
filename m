Return-Path: <linux-kernel-owner+w=401wt.eu-S1751736AbYECSle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbYECSle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 14:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbYECSlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 14:41:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbYECSlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 14:41:22 -0400
Date: Sat, 3 May 2008 11:40:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH v2] unify sys_pipe implementation
In-Reply-To: <200805031801.m43I109q032242@devserv.devel.redhat.com>
Message-ID: <alpine.LFD.1.10.0805031138450.5994@woody.linux-foundation.org>
References: <200805031801.m43I109q032242@devserv.devel.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 3 May 2008, Ulrich Drepper wrote:
> 
> Some arch maintainers might want to take a look at their remaining
> special versions.  The cris version, for instance, only differs from
> the generic version in that it takes the BKL.  Is this still needed
> these days?

No, definitely not.

That said, I think that in order to not break other architectures, and to 
make it even easier to do this transformation, how about we just mark the 
generic version with __weak?

That way, odd architectures can just continue to call their own versions 
"sys_pipe()", and we don't break them unnecessarily.

		Linus
