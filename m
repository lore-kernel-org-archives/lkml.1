Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbYFKAb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbYFKAb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 20:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbYFKAa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 20:30:56 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64354 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754407AbYFKAaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 20:30:55 -0400
Date: Wed, 11 Jun 2008 01:29:47 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       hugh@veritas.com
Subject: Re: [PATCH 11/15] x86: move enabling of io_apic to prepare_cpus
In-Reply-To: <86802c440806101249i3650aa59u1090110a803c3384@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0806110122580.1702@cliff.in.clinika.pl>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com> 
 <Pine.LNX.4.55.0806092058550.26593@cliff.in.clinika.pl> 
 <86802c440806091353m240ab7adocbaf5dacd15504f7@mail.gmail.com> 
 <Pine.LNX.4.55.0806092159350.26593@cliff.in.clinika.pl> 
 <Pine.LNX.4.55.0806100341520.31588@cliff.in.clinika.pl> 
 <86802c440806092208s338cf6b6q892f5149bbd142ca@mail.gmail.com> 
 <484E7B03.8000604@redhat.com>  <Pine.LNX.4.55.0806101418510.1702@cliff.in.clinika.pl>
  <86802c440806101209q301bcef0ia859db7e587bd42e@mail.gmail.com> 
 <Pine.LNX.4.55.0806102025460.1702@cliff.in.clinika.pl>
 <86802c440806101249i3650aa59u1090110a803c3384@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Yinghai Lu wrote:

> ExtINT is routed to ioapic pin0. but the dst is set to 0.
> and the systems has multi sockets with quadcore cpu, so the apic id of boot cpu
> is set to 4 instead of 0

 Thanks for the info.  Let me understand the situation better: local APIC
IDs are preassigned by the firmware based on their "socket address" and
the socket where the lowest numbered quad would be is empty.  
Nevertheless the firmware sets the destination ID of the ExtINTA interrupt
in the I/O APIC to 0 rather than the ID of the bootstrap CPU.  Is that
correct?

 But it would mean the Virtual Wire interrupt delivery would not work, or
is the I/O APIC setup redundant and the local APIC of the bootstrap CPU is
set up for ExtINTA delivery as well?

  Maciej
