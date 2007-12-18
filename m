Return-Path: <linux-kernel-owner+w=401wt.eu-S1765858AbXLRAXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765858AbXLRAXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759701AbXLRAX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:23:27 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41006 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756724AbXLRAX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:23:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <andi@firstfloor.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, Ben Woodard <woodard@redhat.com>,
       Neil Horman <nhorman@redhat.com>, kexec@lists.infradead.org,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       Yinghai Lu <yhlu.kernel@gmail.com>, hpa@zytor.com, tglx@linutronix.de,
       mingo@redhat.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <20071211192434.GD10999@hmsreliant.think-freely.org>
	<86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com>
	<20071211205955.GF10999@hmsreliant.think-freely.org>
	<20071212142132.GC4889@bingen.suse.de>
	<20071212155515.GA29735@hmsendeavour.rdu.redhat.com>
	<20071212160722.GD4889@bingen.suse.de>
	<m1prxbu2ah.fsf@ebiederm.dsl.xmission.com>
	<20071212202215.GB29735@hmsendeavour.rdu.redhat.com>
	<m1lk7ztx9p.fsf@ebiederm.dsl.xmission.com>
	<20071213143922.GA4674@hmsreliant.think-freely.org>
	<20071213151629.GB31269@one.firstfloor.org>
Date: Mon, 17 Dec 2007 17:13:25 -0700
In-Reply-To: <20071213151629.GB31269@one.firstfloor.org> (Andi Kleen's message
	of "Thu, 13 Dec 2007 16:16:29 +0100")
Message-ID: <m1tzmgdfmi.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> On Thu, Dec 13, 2007 at 09:39:22AM -0500, Neil Horman wrote:
>> 
>> Ok, new patch attached, taking into account Andi's request for a cleaner
> method
>
> Sorry for not noticing that earlier, but was there a specific reason this needs
> to be an early quirk at all? kexec can only happen after the standard quirks
> ran.
> I think it should be fine as a standard "late" quirk.

Just to document things.  The important thing is this quirk happens
before calibrate_delay().  Which is still before the normal pci
subsystem gets initialized.  So that seems to require an early_quirk
as the pci subsystem is not initialized by that point.

The only case we are likely to hit this is kdump because BIOS almost
always boot us on the cpu with apic id  == 0.  However in the case
of this bug if we happen to boot on a cpu with apic id >= 16 we
won't be able to boot the linux kernel either, because calibrate_delay
will fail.

Eric
