Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbYAJCqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbYAJCqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 21:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbYAJCq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 21:46:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54262 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbYAJCq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 21:46:28 -0500
Message-ID: <478586E1.8010709@zytor.com>
Date: Wed, 09 Jan 2008 18:45:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jeff Dike <jdike@addtoit.com>, Miklos Szeredi <miklos@szeredi.hu>,
       harvey.harrison@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: uml and -regparm=3
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu> <p734pdmput0.fsf@bingen.suse.de> <E1JCiLx-0006lI-HR@pomaz-ex.szeredi.hu> <20080109213258.GC15612@one.firstfloor.org> <E1JCioy-0006os-6i@pomaz-ex.szeredi.hu> <20080110021404.GA11287@c2.user-mode-linux.org> <20080110023701.GB20813@one.firstfloor.org>
In-Reply-To: <20080110023701.GB20813@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Jan 09, 2008 at 09:14:04PM -0500, Jeff Dike wrote:
>> On Wed, Jan 09, 2008 at 10:50:48PM +0100, Miklos Szeredi wrote:
>>>> FASTCALL is useless and should not make a difference. It enables
>>>> regparm on specific functions, but that should not make a difference
>>>> if it works or not.
>>> __down_write() in include/asm-x86/rwsem.h seems to assume, that the
>>> semaphore pointer is passed in %eax down to rwsem_down_write_failed(),
>>> so regparm does make a difference there.
>> And rwsem_down_write_failed seems to think it's getting the pointer in
>> %eax:
> 
> That's a left over from when it was called by magic inline assembly.
> I suspect it would be better to switch it just over to stack args
> for consistent and then declare it asmlinkage
> 

That seems to go in the wrong direction to me.  It would make more sense 
to gradually shift to asmlinkage actually being regparm=3.  This, of 
course, would require a different name (such as FASTCALL) until the 
conversion is complete -- even if done as a single patch series.

	-hpa
