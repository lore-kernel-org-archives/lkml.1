Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbYFRWTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbYFRWTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 18:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbYFRWS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 18:18:58 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:61153 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYFRWS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 18:18:57 -0400
Date: Wed, 18 Jun 2008 18:18:34 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86: update mptable v7
In-reply-to: <200806011317.38622.yhlu.kernel@gmail.com>
X-X-Sender: lenb@localhost.localdomain
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200805041823.57198.yhlu.kernel@gmail.com>
 <200805191252.36814.yhlu.kernel@gmail.com>
 <200805251600.26325.yhlu.kernel@gmail.com>
 <200806011317.38622.yhlu.kernel@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 1 Jun 2008, Yinghai Lu wrote:

> 
> make mptable to be consistent to acpi routing, so we could
> 1. kexec kernel with acpi=off
> 2. workaround BIOS that acpi routing is working, but mptable is not right.
>    so can use kernel/kexec to start other os that doesn't have good acpi support

Is this an effort to boot an ACPI-mode kernel,
and then kexec a non-ACPI kernel?

Doing so could confuse the heck out of the platform firmware,
which will think that an ACPI-mode kernel is still running.

Note that it is a historic artifact, now considered a bug,
that ACPI uses the MPS code.  We should be divorcing these
two bodies of code rather than mixing them further.

-Len
