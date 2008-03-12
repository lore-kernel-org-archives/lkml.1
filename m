Return-Path: <linux-kernel-owner+w=401wt.eu-S1752415AbYCLBPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbYCLBPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 21:15:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbYCLBO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 21:14:58 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:39656 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYCLBO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 21:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=deryafyltrVnCZNzYSalMq0n8pi/6ffVzy65lpS49bIhIVUFprEa7CV96tp79/7b1V/bS22CarSOYjc7IoLzKqcCiz/ypRXr19F8WKnNAbtPWwMJhSm+P+PU9L/Ocs9FLETADBxh7LePEq5KkwC+0g9CERORDGmvLd8xuCxQNc4=
Message-ID: <a8e1da0803111814h3192f856oe4ffa6e92d1d7a92@mail.gmail.com>
Date: Wed, 12 Mar 2008 09:14:55 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc5-mm1
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I got the following lockdep warning:
(add linux-acpi to cc)

[    0.097109] ACPI: Core revision 20070126
[    0.097282] INFO: trying to register non-static key.
[    0.097355] the code is fine but needs lockdep annotation.
[    0.097428] turning off the locking correctness validator.
[    0.097503] Pid: 0, comm: swapper Not tainted 2.6.25-rc5-mm1 #3
[    0.097578]  [<c0127bf8>] ? printk+0x18/0x20
[    0.097716]  [<c014b01c>] __lock_acquire+0x40c/0x760
[    0.097822]  [<c0181ba0>] ? alloc_debug_processing+0xb0/0x140
[    0.097959]  [<c014b969>] lock_acquire+0x79/0xb0
[    0.098063]  [<c0140204>] ? down_trylock+0x14/0x40
[    0.098197]  [<c03df9e8>] _spin_lock_irqsave+0x48/0xa0
[    0.098303]  [<c0140204>] ? down_trylock+0x14/0x40
[    0.098436]  [<c0140204>] down_trylock+0x14/0x40
[    0.098540]  [<c027c7ea>] acpi_os_wait_semaphore+0x3e/0xb9
[    0.098647]  [<c029263e>] acpi_ut_acquire_mutex+0x34/0x72
[    0.098753]  [<c0289ab1>] acpi_ns_root_initialize+0x19/0x250
[    0.098859]  [<c05453e6>] acpi_initialize_subsystem+0x42/0x64
[    0.098966]  [<c0545725>] acpi_early_init+0x50/0xef
[    0.099070]  [<c052b7f6>] start_kernel+0x1e6/0x250
[    0.099175]  [<c052b1a0>] ? unknown_bootoption+0x0/0x130
[    0.099310]  [<c052b008>] __init_begin+0x8/0x10
[    0.099414]  =======================
