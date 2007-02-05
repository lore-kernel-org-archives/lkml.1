Return-Path: <linux-kernel-owner+w=401wt.eu-S933383AbXBEUyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933383AbXBEUyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 15:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933420AbXBEUyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 15:54:24 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:8504 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933383AbXBEUyX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 15:54:23 -0500
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 2/2] x86_64 irq: Handle irqs pending in IRR during
 irq migration.
Date: Mon, 5 Feb 2007 12:54:13 -0800
Message-ID: <5986589C150B2F49A46483AC44C7BCA4907416@ssvlexmb2.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] x86_64 irq: Handle irqs pending in IRR during
 irq migration.
Thread-Index: AcdJZYwBOPAfC7JbT2ej+Fhi/za5hQAAYoBg
From: "Lu, Yinghai" <yinghai.lu@amd.com>
To: ebiederm@xmission.com
cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "Luigi Genoni" <luigi.genoni@pirelli.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Natalie Protasevich" <protasnb@gmail.com>
X-OriginalArrivalTime: 05 Feb 2007 20:54:13.0913 (UTC)
 FILETIME=[CAF91890:01C74967]
X-WSS-ID: 69D946FF1WC6095958-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: ebiederm@xmission.com [mailto:ebiederm@xmission.com] 
Sent: Monday, February 05, 2007 12:37 PM


>The only corner case I can see that might potentially happen is
>"apic_in_service_vector() != irq_vector[irq]" and if that is the case
>we don't want to migrate, because the precondition that we are in the
>irq handler servicing the expected irq isn't true.

Reuse vector could help in that case.

In another case, if two irq are migrated from one cpu to another cpu.
ack_apic_edge for irq2 could use get apci_in_servier_vector for irq1,
and handle that to clear irr for irq1. instead of irq2.

YH




