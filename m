Return-Path: <linux-kernel-owner+w=401wt.eu-S1758328AbYGRWDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328AbYGRWDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYGRWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:03:09 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:65034 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752774AbYGRWDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:03:08 -0400
Date: Fri, 18 Jul 2008 23:02:12 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [PATCH] x86: APIC: Remove apic_write_around(); use alternatives
In-Reply-To: <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com>
Message-ID: <Pine.LNX.4.55.0807182254270.12125@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807161837080.30858@cliff.in.clinika.pl> 
 <20080718105259.GY6875@elte.hu>  <86802c440807180925t6fadfa58r6bf7740f8145482e@mail.gmail.com>
  <86802c440807181001h4426c197vc474f81497a5b42@mail.gmail.com> 
 <20080718210348.GB24373@elte.hu> <86802c440807181413n7e79e821l90afaae86b322de9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, Yinghai Lu wrote:

>   CC      arch/x86/kernel/apic_64.o
> arch/x86/kernel/apic_64.c:170: error: unknown field 'write_atomic'
> specified in initializer
> arch/x86/kernel/apic_64.c:170: error: 'native_apic_mem_write_atomic'
> undeclared here (not in a function)
> arch/x86/kernel/apic_64.c:209: error: unknown field 'write_atomic'
> specified in initializer
> arch/x86/kernel/apic_64.c:209: warning: initialization from
> incompatible pointer type
> make[1]: *** [arch/x86/kernel/apic_64.o] Error 1
> make: *** [arch/x86/kernel] Error 2

 Just remove the offending initialisers.  They are not needed anymore as
the .write method is now used universally including places where
.write_atomic was.  I just could not stand watching the thing
proliferate...

  Maciej
