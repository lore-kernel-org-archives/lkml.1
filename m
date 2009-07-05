Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZGERM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZGERM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 13:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbZGERMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 13:12:49 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47939 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbZGERMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 13:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XfurWIJEPxAv4x/8RxsJbcMCq3LAs+C+afJjuqAW7n3oxu8Hz/qUSDa0RmyylP43nG
         yGQAWv8gYf66iVabd0WgnTB1CgBKeXfRUXcZBcys+Fw1ywrmbK9+jzmOw1SSde8OGcA4
         8aJBaRmfJe6or9PZS/DDgp+fsDDhhY47EFlZM=
Date: Sun, 5 Jul 2009 21:12:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic -- reduce disable_apic usage
Message-ID: <20090705171251.GE4791@lenovo>
References: <20090705162044.GC4791@lenovo> <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org> <20090705165947.GD4791@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705165947.GD4791@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sun, Jul 05, 2009 at 08:59:47PM +0400]
| [Maciej W. Rozycki - Sun, Jul 05, 2009 at 05:38:52PM +0100]
| | On Sun, 5 Jul 2009, Cyrill Gorcunov wrote:
| | 
| | > Here is an attempt to bring more consistency for apic
| | > presence check. I hope I covered all the code flows.
| | > Though it's RFC. Please review and test if possible.
| | > 
| | > 	-- Cyrill
| | > ---
| | > Instead of messing with (cpu_has_apic|disable_apic)
| | > to check if we have apic functional, better to distinguish
| | > them by logical kind. cpu_has_apic -- to check if we may
| | > use apic functionality, disable_apic -- to note that
| | > apic was disabled via command line.
| | 
| |  How do you set cpu_has_apic for systems with discrete local APICs?  The 
| | CPUID flag is not set in this case.
| | 
| |   Maciej
| | --
| | 
| 
| Well, indeed, somehow forgot about this case. Thanks Maciej!
| The patch should be dropped.
| 
| 	-- Cyrill

Hmm... But if we have no MP table parsed and no "lapic" option
passed we should leave execution in pure PIC mode. Or I miss
something?

	-- Cyrill
