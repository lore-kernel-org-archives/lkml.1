Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYJVTva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYJVTva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYJVTvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:51:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59025 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbYJVTvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:51:21 -0400
Date: Wed, 22 Oct 2008 21:58:45 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alok Kataria <akataria@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is set.
Message-ID: <20081022195845.GP12825@one.firstfloor.org>
References: <1224552902.2640.88.camel@alok-dev1> <874p36fflp.fsf@basil.nowhere.org> <1224607284.6161.22.camel@alok-dev1> <20081021174008.GH12825@one.firstfloor.org> <1224612294.6161.43.camel@alok-dev1> <20081021181536.GI12825@one.firstfloor.org> <1224616236.6161.60.camel@alok-dev1> <20081021192746.GJ12825@one.firstfloor.org> <1224703427.13953.8.camel@alok-dev1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224703427.13953.8.camel@alok-dev1>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We also force set the CONSTANT_TSC capability bit if we are running on
> VMware, since the VMware hypervisor exports a constant TSC to the guest.

NAK.

The whole point of this is to eliminate the need for vmware detection,
which is something the kernel shouldn't need to know about.
Instead VMware should supply that bit by itself and then Linux could
do the right thing. The only change you would need to do is to always
check it for all CPU vendors, not just AMD.
Adding it with vmware detection code is not useful.

-Andi
