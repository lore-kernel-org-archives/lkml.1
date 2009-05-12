Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbZELGWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbZELGWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 02:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbZELGW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 02:22:27 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43755 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692AbZELGW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 02:22:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18953.5533.398597.677737@drongo.ozlabs.ibm.com>
Date: Tue, 12 May 2009 16:22:21 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
In-Reply-To: <1242108700.11251.304.camel@twins>
References: <20090508165219.469818319@chello.nl>
	<20090508170028.837558214@chello.nl>
	<200905120158.46314.arnd@arndb.de>
	<1242108700.11251.304.camel@twins>
X-Mailer: VM 8.0.12 under 22.3.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Hmm, are you saying that the 3rd argument to unlocked_ioctl is actually
> (void __user *) instead of unsigned long?

He's saying (correctly) that using _IOR or _IOW implies that the ioctl
is going to read or write the memory location pointed to by the 3rd
argument to unlocked_ioctl.  If the 3rd argument is just a number, not
an address, I believe you should use _IO.

Paul.
