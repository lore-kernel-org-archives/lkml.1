Return-Path: <linux-kernel-owner+w=401wt.eu-S1757344AbZDPQcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344AbZDPQcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbZDPQb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:31:58 -0400
Received: from outbound-mail-106.bluehost.com ([69.89.22.6]:37192 "HELO
	outbound-mail-106.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756816AbZDPQb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:31:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=STBc3W6VMqPs1Aksc/f3yq+s6oqGXicGPi7zkrvjMPhz8l4Gy5Jsz/xbE/kpfgrP/Lz6f+PdvuHnmf7PLZTpvZvZmpS/PP/LEFF9pKHp1szDWQZoWNCi3rdgrvaLmFST;
Date: Thu, 16 Apr 2009 09:31:52 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v3
Message-ID: <20090416093152.6605612d@hobbes>
In-Reply-To: <49E52D3F.1090206@kernel.org>
References: <bug-11103-13546@http.bugzilla.kernel.org/>
	<200904101913.n3AJDhMm018684@demeter.kernel.org>
	<49DFABCC.3070001@kernel.org>
	<49E00E9F.8030605@kernel.org>
	<49E4F6D6.6030709@kernel.org>
	<49E4F71F.10107@kernel.org>
	<alpine.LFD.2.00.0904141359020.18124@localhost.localdomain>
	<49E52A7A.4070607@kernel.org>
	<49E52D3F.1090206@kernel.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 17:41:35 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: make more big space below 4g for assigning to unassigned pci
> devices
> 
> don't need to reserved one round after the gapstart.
> 
> v2: Linus said: "
> 	We've definitely seen ACPI code or integrated graphics stuff 
> 	that steals a lot of memory at the end, which means that
> end-of-RAM might be not at 2GB, but at 2GB-16MB-1MB, for example (1MB
> of "ACPI data", and 16MB of "stolen video ram").
> 
> 	At a minimum, if we do this, I'd like to make sure we round
> up to a big boundary (eg 32MB or something - exactly because a
> missing 16MB can easily be some integrated stolen video memory).
> 
> 	Sure, we do that whole
> 
> 		while ((gapsize >> 4) > round)
> 			round += round;
> 
> 	thing, so that if the gap is large, then we'll certainly get
> to 32MB too, but I think your patch matters the most exactly when the
> gap is small. Maybe we could just raise the initial minimum rounding
> from 1MB to 32MB? ...
> 	Alternatively, maybe we can make sure that we round up to at
> least X bytes from the end of RAM, and to at least Y bytes from the
> end of some RESERVED thing."
> v3: take pci_mem_start - low_top_ram bigger than half around, aka 16M
> at least

Any comments on this one, Linus?  Should I include your ack?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
