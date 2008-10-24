Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYJXHP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYJXHP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752182AbYJXHPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:15:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48559 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbYJXHPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:15:48 -0400
Date: Fri, 24 Oct 2008 09:23:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, akataria@vmware.com,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is set.
Message-ID: <20081024072320.GE27492@one.firstfloor.org>
References: <1224712846.13953.37.camel@alok-dev1> <20081022221316.GW12825@one.firstfloor.org> <1224713518.13953.46.camel@alok-dev1> <20081022225409.GB27492@one.firstfloor.org> <1224728478.13953.79.camel@alok-dev1> <20081023081052.GI27492@one.firstfloor.org> <1224805162.21776.45.camel@alok-dev1> <49010D1E.8070400@zytor.com> <20081024002511.GC27492@one.firstfloor.org> <49011AD7.7000901@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49011AD7.7000901@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That is at least to some degree nonsense, simply because we are all well 
> down that particular "slippery slope": we have hardware blacklists and 

The big difference is that hardware cannot be easily fixed, hypervisors
are just software and can as simply as Linux. Also there are at least 
standardized simple ways to detect hardware and platforms using standard 
enumeration interfaces like PCI or DMI, while each Hypervisor detection 
seems to need huge amounts of custom (and likely fragile) complicated code.
iirc there was a vmware detection patch around and it was disgusting iirc.

Also I think this concept of "not PV, but then again a little"
concept that is mandated here is not a useful one.

Either do a proper PV interface and then just write a custom
clock driver and paravirt ops interface to make everything really fast,
or just use the direct hardware interface and fix the hypervisor
to do it properly.

Especially VMware has this already (although 32bit only).

Ok the tsc_sync issue is borderline, but that one seems 
to be more a case of tweaking the existing algorithms
to be a little more tolerant.

-Andi
-- 
ak@linux.intel.com
