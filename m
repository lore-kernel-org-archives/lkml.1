Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYJXAqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYJXAqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 20:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYJXAqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 20:46:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37654 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbYJXAqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:46:43 -0400
Message-ID: <49011AD7.7000901@zytor.com>
Date: Thu, 23 Oct 2008 17:46:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
 set.
References: <1224703427.13953.8.camel@alok-dev1> <20081022195845.GP12825@one.firstfloor.org> <1224712846.13953.37.camel@alok-dev1> <20081022221316.GW12825@one.firstfloor.org> <1224713518.13953.46.camel@alok-dev1> <20081022225409.GB27492@one.firstfloor.org> <1224728478.13953.79.camel@alok-dev1> <20081023081052.GI27492@one.firstfloor.org> <1224805162.21776.45.camel@alok-dev1> <49010D1E.8070400@zytor.com> <20081024002511.GC27492@one.firstfloor.org>
In-Reply-To: <20081024002511.GC27492@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> As far as skipping the check, it makes sense for me in the case of known 
>> virtualization platforms; a CPU feature bit, real or synthetic, is a 
>> very clean way to do that. 
> 
> I don't think adding detection for non PV Hypervisors is anywhere clean
> Even if it's only VMware today, tomorrow it will be a few more
> and long term you might need to support all of the obscuro hypervisors
> that are out there. Just seems like a slippery slope. Either it's 
> paravirtual or it's not, but it should attempt to be both. If the hypervisor
> doesn't emulate TSC well enough that the native code works it's entirely
> reasonable to let it use some other timer, like it has been always
> done in the past.

That is at least to some degree nonsense, simply because we are all well 
down that particular "slippery slope": we have hardware blacklists and 
whitelists, CPU-specific workarounds, and so on all over the place, and 
in that sense a hypervisor really isn't different than another hardware 
platform.

	-hpa
