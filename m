Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZEQVzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZEQVzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 17:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754203AbZEQVzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 17:55:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:54081 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZEQVze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 17:55:34 -0400
Subject: Re: [PATCH] [PowerPC] Support For Initrd Loaded Into Highmem
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Konstantin Baydarov <kbaidarov@ru.mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4A103EDF.7050108@ru.mvista.com>
References: <4A103EDF.7050108@ru.mvista.com>
Content-Type: text/plain
Date: Mon, 18 May 2009 07:55:03 +1000
Message-Id: <1242597303.18075.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Also if initrd is in the highmem, uBoot adds initrd highmem region into the
> initial_boot_params->off_mem_rsvmap. This leads to kernel crash, because kernel
> assumes that regions from the initial_boot_params->off_mem_rsvmap are in the
> lowmem. So patch skips initrd highmem region when kernel reserves lowmem regions
> in early_reserve_mem().
> 
>   This patch is for linux-2.6.30-rc6.

Fixing the reserve map isn't the right approach.

We should be able to have anything in there. It's the kernel that should
be more careful at coping if it contains things that aren't in lowmem.

Cheers,
Ben.


