Return-Path: <linux-kernel-owner+w=401wt.eu-S933973AbXCKS3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973AbXCKS3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 14:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933980AbXCKS3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 14:29:16 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46352 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933973AbXCKS3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 14:29:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
References: <20070311112400.GB24475@mellanox.co.il>
	<m1ird7y93j.fsf@ebiederm.dsl.xmission.com>
	<20070311180342.GE24475@mellanox.co.il>
Date: Sun, 11 Mar 2007 12:27:40 -0600
In-Reply-To: <20070311180342.GE24475@mellanox.co.il> (Michael S. Tsirkin's
	message of "Sun, 11 Mar 2007 20:03:42 +0200")
Message-ID: <m1mz2jws83.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@mellanox.co.il> writes:

>> Rumor has it that some pci devices can't tolerate < 32bit accesses.
>> Although I have never met one.
>
> hopefully not bridge devices?
>
>> The two factors together suggest that
>> for generic code it probably makes sense to operate on 32bit
>> quantities, and just to ignore the read-only portion.
>
> The code for regular devices seems to use 16-bit accesses, so
> I think it's best to stay consistent. Or do you want to change this too?

If we are stomping rare probabilities we might as well change that too.
The code to save pci-x state is relatively recent.  So it probably just
hasn't met a problem device yet (assuming they exist).

Eric
