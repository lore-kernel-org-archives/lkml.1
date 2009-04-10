Return-Path: <linux-kernel-owner+w=401wt.eu-S1762785AbZDJWAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762785AbZDJWAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbZDJWAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:00:13 -0400
Received: from www.tglx.de ([62.245.132.106]:58910 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZDJWAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:00:11 -0400
Date: Fri, 10 Apr 2009 23:59:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: jvrao <jvrao@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Mike Anderson <andmike@linux.vnet.ibm.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       linux-driver@qlogic.com
Subject: Re: Interrupts are being dropped under heavy IO on -rt .
In-Reply-To: <49DF71CF.7070509@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0904102357470.21577@localhost.localdomain>
References: <49DF71CF.7070509@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009, jvrao wrote:
> Qlogic driver uses MSI-EDGE interrupts by default.
> 
> On -rt kernel under heavy IO load we observed that the driver missed
> interrupts occasionally.
> 
> Missing interrupts caused spurious mailbox timeouts and path failovers.
> 
> Suspecting MSI interrupts, we disabled MSI and forcing the driver to use APIC
> interrupts (Patch attached).
> 
> With this change, our IO tests ran for extended period of time without any
> issues.
> 
> It would be interesting to see if the MSI infrastructure itself has issues on
> realtime, or it is the combination of qla2xxx/MSI.
> 
> Right now we don't have any setup to test out MSI with other adapters. Hence,
> wondering if anyone faced similar issues.

Hmm. Can we get down to the root cause of that problem instead of
applying a bandaid patch ?

If -rt has problems with MSI edge interrupts then we really need to
figure out why. If the qlogic driver has problems with the different
timings of -rt then we need to fix that one.

Thanks,

	tglx
