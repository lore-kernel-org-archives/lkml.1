Return-Path: <linux-kernel-owner+w=401wt.eu-S1765756AbYETVh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765756AbYETVh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761264AbYETVhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:37:16 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:64910 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759761AbYETVhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:37:14 -0400
Message-ID: <483344C0.3020703@freescale.com>
Date: Tue, 20 May 2008 16:38:08 -0500
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: Trent Piepho <tpiepho@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com> <1211318219.8297.177.camel@pasglop>
In-Reply-To: <1211318219.8297.177.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Tue, 2008-05-20 at 13:40 -0700, Trent Piepho wrote:
>> There was some discussion on a Freescale list if the powerpc I/O accessors
>> should be strictly ordered w.r.t.  normal memory.  Currently they are not.  It
>> does not appear as if any other architecture's I/O accessors are strictly
>> ordered in this manner.  memory-barriers.txt explicitly states that the I/O
>> space (inb, outw, etc.) are NOT strictly ordered w.r.t. normal memory
>> accesses and it's implied the other I/O accessors (e.g., writel) are the same.
>>
>> However, it is somewhat harder to program for this model, and there are almost
>> certainly a number of drivers using coherent DMA which have subtle bugs because
>> the do not include the necessary barriers.
>>
>> But clearly and change to this would be a subject for a different patch.
> 
> The current accessors should provide all the necessary ordering
> guarantees...

It looks like we rely on -fno-strict-aliasing to prevent reordering 
ordinary memory accesses (such as to DMA descriptors) past the I/O 
access.  It won't prevent reordering of memory reads around an I/O read, 
though, which could be a problem if the I/O read result determines the 
validity of the DMA buffer.  IMHO, a memory clobber would be better.

-Scott
