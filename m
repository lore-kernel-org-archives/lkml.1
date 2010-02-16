Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab0BPAax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 19:30:53 -0500
Received: from snt0-omc4-s36.snt0.hotmail.com ([65.55.90.239]:9262 "EHLO
	snt0-omc4-s36.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932299Ab0BPAaw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 19:30:52 -0500
Message-ID: <SNT125-W34AEECE0C00025B544A35C3490@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <macro@linux-mips.org>, <sassmann@suse.de>
CC: <ebiederm@xmission.com>, <od@suse.de>, <tglx@linutronix.de>,
       <mingo@elte.hu>, <hpa@zytor.com>, <jonathan@jonmasters.org>,
       <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/7] Boot IRQ quirks and rerouting
Date: Mon, 15 Feb 2010 16:30:51 -0800
Importance: Normal
In-Reply-To: <Pine.LNX.4.55.0806041555370.28685@cliff.in.clinika.pl>
References: <12124107071847-git-send-email-od@suse.de>
 <m1tzgauduu.fsf@frodo.ebiederm.org> <4846651F.4070802@suse.de>
 <m1ve0pqy06.fsf@frodo.ebiederm.org>
 <48467DA7.9030309@suse.de>,<Pine.LNX.4.55.0806041555370.28685@cliff.in.clinika.pl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Feb 2010 00:30:51.0433 (UTC) FILETIME=[4AF8C190:01CAAE9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Well, this is clear these chipsets are broken beyond imagination,
> negating some 15 years of I/O APIC compatibility where masking an input in
> its redirection table is expected not to have any side effects. They
> should have used a separate bit for the legacy INTx redirection. That has
> been fixed in hardware though and there is nothing we can do about it at
> this stage. Hire competent hardware designers the next time.
I think part of it has to do with how chipset vendors integrated the first I/O APIC into the southbridge around 1999-2001 (Intel was first to do so back in 1999, I think), which were necessary if there were any hope of putting them in uniprocessor systems. Unfortunately, the way it was integrated, the interrupt pins that goes outside the southbridge was shared with both the 8259 PICs (via a PIR) AND the first I/O APIC, and there was no way to do otherwise. While that was very convenient for single I/O APIC systems, on multiple I/O APIC systems it can cause boot interrupts to be delivered to the first I/O APIC as well as the PIC which could be very bad, as you have seen.

Yuhong Bao
 		 	   		  
_________________________________________________________________
Hotmail: Powerful Free email with security by Microsoft.
http://clk.atdmt.com/GBL/go/201469230/direct/01/