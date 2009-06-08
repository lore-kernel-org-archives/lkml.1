Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbZFHFoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbZFHFoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 01:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbZFHFnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 01:43:52 -0400
Received: from www.tglx.de ([62.245.132.106]:54253 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZFHFnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 01:43:52 -0400
Date: Mon, 8 Jun 2009 07:43:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shaohua.li@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH] tick: add check for the existence of broadcast clock
 event device
In-Reply-To: <20090608095730.0c945e78@feng-desktop>
Message-ID: <alpine.LFD.2.00.0906080739020.3419@localhost.localdomain>
References: <20090605112711.67e7d5cb@feng-desktop> <alpine.LFD.2.00.0906061121330.3419@localhost.localdomain> <20090606204736.00700bd0@feng-desktop> <alpine.LFD.2.00.0906061450220.3419@localhost.localdomain> <alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
 <20090608095730.0c945e78@feng-desktop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Feng Tang wrote:
> > 1) How do you calibrate the local APIC timer if you do not have some
> > initial timer device ?
> Yes, we have external timer device with the name "apbt"

So that timer is initialized and registered before the local apic,
right ?

Why is the local APIC timer used at all ? The apbt timer should have a
higher rating as the local APIC timer, so when APIC is registered it
is not selected and the check in the broadcast functions

   !(dev->features & CLOCK_EVT_FEAT_C3STOP))

should protect you because that bit is not set on your apbt device.

Thanks,

	tglx
