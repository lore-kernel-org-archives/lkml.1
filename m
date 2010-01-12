Return-Path: <linux-kernel-owner+w=401wt.eu-S1752730Ab0ALUhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab0ALUhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 15:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511Ab0ALUhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 15:37:11 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:47533 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0ALUhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 15:37:10 -0500
Date: Tue, 12 Jan 2010 14:31:53 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Yinghai Lu <yinghai@kernel.org>
cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] use nr_cpus= to set nr_cpu_ids early
In-Reply-To: <86802c441001121157y5cdc1a91g2a66d8591d6fd579@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1001121426450.25925@router.home>
References: <1263298146-25597-1-git-send-email-yinghai@kernel.org>  <alpine.DEB.2.00.1001121331590.25925@router.home> <86802c441001121157y5cdc1a91g2a66d8591d6fd579@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010, Yinghai Lu wrote:

> > Why do we need this twice?
>
> maxcpus only change setup_max_cpus., and if you are using maxcpus=1,
> and you have 8 cpus installed, you can put other
> cpus back online via /sys/interface.

Hmmm.. Strange semantics since maxcpus=0 disables smp completely. No cpu
can be activated later. Similar to nr_cpus ?

> nr_cpus= is hard limit nr_cpu_ids, so if you have 16 cpus installed,
> nr_cpus=8 will make your nr_cpu_ids=8, and you can not put back
> other 8 back. and apic mode could stay with logical flat.
> this is used to simulate some debug case. for example you have kernel
> support physflat, and flat, with CONFIG_NR_CPUS=255. to run that on
> system that only have 8 cpus, you will have apic mode in logical flat.
>  but if you have run the kernel on system with 32 cpus installed, it
> will switch to physflat even you have maxcpus=8 appedded.

Ok makes sense.
