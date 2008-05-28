Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbYE1Pg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbYE1Pg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 11:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYE1PgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 11:36:21 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61645 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbYE1PgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 11:36:20 -0400
Date: Wed, 28 May 2008 16:35:14 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/11] x86: nmi_32/64.c - use apic_write_around instead
 of apic_write
In-Reply-To: <48383740.0407560a.4764.7d1b@mx.google.com>
Message-ID: <Pine.LNX.4.55.0805281628320.29522@cliff.in.clinika.pl>
References: <20080524153630.669797039@gmail.com>> <48383740.0407560a.4764.7d1b@mx.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008, Cyrill Gorcunov wrote:

> apic_write_around will be expanded to apic_write in 64bit mode
> anyway. Only a few CPUs (well, old CPUs to be precise) requires
> such an action. In general it should not hurt and could be cleaned
> up for apic_write (just in case)
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 Almost all local APIC write accesses must use apic_write_around().  The
notable exceptions are appropriately guarded accesses to the ESR (there is
no need ever to write to this register on Pentium processors and a read of
the register has side-effects) and pieces of code known never to run on
original Pentium processors.

  Maciej
