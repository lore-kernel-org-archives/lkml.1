Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbXHSWdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbXHSWdw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbXHSWdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:33:40 -0400
Received: from mx1.suse.de ([195.135.220.2]:50517 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbXHSWdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:33:39 -0400
To: "Felix Marti" <felix@chelsio.com>
Cc: "David Miller" <davem@davemloft.net>, jeff@garzik.org,
       netdev@vger.kernel.org, rdreier@cisco.com, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
References: <000001c7e22e$b7b90f00$29c8180a@amr.corp.intel.com>
	<20070819.002337.06589160.davem@davemloft.net>
	<8A71B368A89016469F72CD08050AD334018E208F@maui.asicdesigners.com>
	<20070819.123212.13769462.davem@davemloft.net>
	<8A71B368A89016469F72CD08050AD334018E209C@maui.asicdesigners.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Aug 2007 01:27:35 +0200
In-Reply-To: <8A71B368A89016469F72CD08050AD334018E209C@maui.asicdesigners.com>
Message-ID: <p73hcmv14wo.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Felix Marti" <felix@chelsio.com> writes:

> what benefits does the TSO infrastructure give the
> non-TSO capable devices?

It improves performance on software queueing devices between guests
and hypervisors. This is a more and more important application these
days.  Even when the system running the Hypervisor has a non TSO
capable device in the end it'll still save CPU cycles this way. Right now
virtualized IO tends to much more CPU intensive than direct IO so any
help it can get is beneficial.

It also makes loopback faster, although given that's probably not that
useful.

And a lot of the "TSO infrastructure" was needed for zero copy TX anyways,
which benefits most reasonable modern NICs (anything with hardware 
checksumming)

-Andi
