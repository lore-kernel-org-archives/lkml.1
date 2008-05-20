Return-Path: <linux-kernel-owner+w=401wt.eu-S934615AbYETW0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615AbYETW0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765127AbYETW02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:26:28 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:40131 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933422AbYETW01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:26:27 -0400
Date: Tue, 20 May 2008 15:21:13 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [POWERPC] Improve (in|out)_beXX() asm code
In-Reply-To: <1211320938.8297.179.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0805201511300.7453@t2.domain.actdsltmp>
References: <1211316025-29069-1-git-send-email-tpiepho@freescale.com> 
 <1211318219.8297.177.camel@pasglop>  <483344C0.3020703@freescale.com>
 <1211320938.8297.179.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Benjamin Herrenschmidt wrote:
> On Tue, 2008-05-20 at 16:38 -0500, Scott Wood wrote:
>> It looks like we rely on -fno-strict-aliasing to prevent reordering
>> ordinary memory accesses (such as to DMA descriptors) past the I/O
>> access.  It won't prevent reordering of memory reads around an I/O
>> read,
>> though, which could be a problem if the I/O read result determines
>> the
>> validity of the DMA buffer.  IMHO, a memory clobber would be better.
>
> We probably want a full "memory" clobber then...

As far as I could tell, no other arch has a full memory clobber.  I can see
the argument for changing the Linux model to be stricter and less efficient,
but easier to program for.  Not that I entirely agree with it.

But I don't see a good reason for why powerpc should be different than
everything else.
