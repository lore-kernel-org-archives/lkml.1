Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724Ab0ATXqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab0ATXqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835Ab0ATXqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:46:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749Ab0ATXqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:46:31 -0500
Date: Wed, 20 Jan 2010 15:46:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [x86] Unify semaphore_32.S and rwlock_64.S
In-Reply-To: <4B57641E.5060303@zytor.com>
Message-ID: <alpine.LFD.2.00.1001201542000.13231@localhost.localdomain>
References: <alpine.DEB.2.00.1001191616280.28622@router.home> <4B56328E.9080108@zytor.com> <alpine.DEB.2.00.1001201333430.15175@router.home> <4B57641E.5060303@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 20 Jan 2010, H. Peter Anvin wrote:
> 
> The motivation for rwsem_count_t seemed to be making it easier to switch
> over.  I leave it up to Linus to motivate the typedef...

Indeed. I wanted to separate the issue of cleaning up the mask values from 
cleaning up the code. That required that we'd have a separate type that 
can change in _one_ place with the bias values.

It was also an unholy type mess before, so the rwsem_count_t also was 
about making that unholy mess clearer. That's especially true since the 
type will also have to percolate down to the slow cases before you can 
actually fix the BIAS values.

As to keeping the 64-bit and 32-bit slow case wrappers separate: this is 
very much one case where we _have_ to. Trying to pretend that 32-bit code 
and 64-bit code is similar in this case is just lying. The calling 
conventions are totally different, there is nothing similar there at all 
(different argument registers, different clobbered registers, different 
_everything_ that matters for the wrapper).

		Linus
