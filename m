Return-Path: <linux-kernel-owner+w=401wt.eu-S1767335AbXECCbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767335AbXECCbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 22:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767338AbXECCbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 22:31:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:48765 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767335AbXECCbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 22:31:14 -0400
Date: Wed, 2 May 2007 19:31:09 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Bill Irwin <bill.irwin@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       wli@holomorphy.com
Subject: Re: [PATCH] i386: fix suspend/resume with dynamically allocated irq stacks
Message-ID: <20070503023109.GE26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46394139.605@goop.org> <20070503022534.GD26598@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503022534.GD26598@holomorphy.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 06:56:09PM -0700, Jeremy Fitzhardinge wrote:
>> +static void __cpuinit __free_irqstack(int cpu, void *stk)
>> +{
>> +	int i;
>> +
>> +	if (!cpu)
>> +		return;
>> +
>> +	unmap_vm_area(per_cpu(irqstack_area, cpu));
>> +
>> +	for (i = 0; i < THREAD_SIZE/PAGE_SIZE; ++i)
>> +		__free_page(per_cpu(irqstack_pages, cpu)[i]);
>> +}

On Wed, May 02, 2007 at 07:25:34PM -0700, Bill Irwin wrote:
[...]

Not sure if cpu 0 can ever be offlined, but it is remapped and so on.
So its virtual mapping should be undone if it can be offlined, but we
probably shouldn't attempt to free its underlying bootmem allocation.


-- wli
