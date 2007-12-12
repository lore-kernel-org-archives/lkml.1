Return-Path: <linux-kernel-owner+w=401wt.eu-S1760112AbXLLTyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760112AbXLLTyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbXLLTyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:54:09 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39811 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbXLLTyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:54:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andi Kleen <ak@suse.de>
Cc: Neil Horman <nhorman@tuxdriver.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ben Woodard <woodard@redhat.com>, Neil Horman <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       hbabu@us.ibm.com, Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
References: <m1ejdt25x0.fsf@ebiederm.dsl.xmission.com>
	<20071211143910.GA10999@hmsreliant.think-freely.org>
	<m1ve75z1v3.fsf@ebiederm.dsl.xmission.com>
	<20071211182254.GB10999@hmsreliant.think-freely.org>
	<m1ejdtysqd.fsf@ebiederm.dsl.xmission.com>
	<20071211192434.GD10999@hmsreliant.think-freely.org>
	<86802c440712111151t29acd38kf9fac8e41743f3e4@mail.gmail.com>
	<20071211205955.GF10999@hmsreliant.think-freely.org>
	<20071212142132.GC4889@bingen.suse.de>
	<20071212155515.GA29735@hmsendeavour.rdu.redhat.com>
	<20071212160722.GD4889@bingen.suse.de>
Date: Wed, 12 Dec 2007 12:43:34 -0700
In-Reply-To: <20071212160722.GD4889@bingen.suse.de> (Andi Kleen's message of
	"Wed, 12 Dec 2007 17:07:22 +0100")
Message-ID: <m1prxbu2ah.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:
>
> It could enable the extended APIC IDs but not use them? 

In which case complaining is still correct (the BIOS was out of sync),
enabling bit 17 is still correct and we are just in overkill mode.

> Anyways I haven't got docs on that NV bridge so I might be wrong.

This has everything to do with how AMD coherent hypertransport works and
little if anything to do with how the NV bridge operated.

Basically the NV bridge seems to be sending a standard hypertransport
x86 legacy interrupt packet (that doesn't have any target information)
and when that packet  hits the coherent hypertransport domain it isn't
being converted into whatever would send it to all cpus. 

.....

The real practical problem is if somehow the BIOS goofs up this way
and it then decides to ask us to boot on one of these cpus with
an extended apic id.  We will hang in calibrate_delay.  So far
this only seems to happen in the kdump case but in theory the BIOS
could be completely crazy.

Eric
