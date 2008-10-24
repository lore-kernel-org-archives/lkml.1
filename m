Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbYJXARt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbYJXARt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 20:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751813AbYJXARm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 20:17:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41569 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYJXARl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 20:17:41 -0400
Date: Fri, 24 Oct 2008 02:25:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akataria@vmware.com, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is set.
Message-ID: <20081024002511.GC27492@one.firstfloor.org>
References: <1224703427.13953.8.camel@alok-dev1> <20081022195845.GP12825@one.firstfloor.org> <1224712846.13953.37.camel@alok-dev1> <20081022221316.GW12825@one.firstfloor.org> <1224713518.13953.46.camel@alok-dev1> <20081022225409.GB27492@one.firstfloor.org> <1224728478.13953.79.camel@alok-dev1> <20081023081052.GI27492@one.firstfloor.org> <1224805162.21776.45.camel@alok-dev1> <49010D1E.8070400@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49010D1E.8070400@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As far as skipping the check, it makes sense for me in the case of known 
> virtualization platforms; a CPU feature bit, real or synthetic, is a 
> very clean way to do that. 

I don't think adding detection for non PV Hypervisors is anywhere clean
Even if it's only VMware today, tomorrow it will be a few more
and long term you might need to support all of the obscuro hypervisors
that are out there. Just seems like a slippery slope. Either it's 
paravirtual or it's not, but it should attempt to be both. If the hypervisor
doesn't emulate TSC well enough that the native code works it's entirely
reasonable to let it use some other timer, like it has been always
done in the past.

-Andi
