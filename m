Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbYFSAeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbYFSAeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 20:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756024AbYFSAeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 20:34:07 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:47634 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbYFSAeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 20:34:06 -0400
Date: Wed, 18 Jun 2008 20:33:35 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] x86: update mptable v7
In-reply-to: <86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
X-X-Sender: lenb@localhost.localdomain
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200805041823.57198.yhlu.kernel@gmail.com>
 <200805191252.36814.yhlu.kernel@gmail.com>
 <200805251600.26325.yhlu.kernel@gmail.com>
 <200806011317.38622.yhlu.kernel@gmail.com>
 <alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>
 <86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 18 Jun 2008, Yinghai Lu wrote:

> On Wed, Jun 18, 2008 at 3:18 PM, Len Brown <lenb@kernel.org> wrote:
> >
> >
> > On Sun, 1 Jun 2008, Yinghai Lu wrote:
> >
> >>
> >> make mptable to be consistent to acpi routing, so we could
> >> 1. kexec kernel with acpi=off
> >> 2. workaround BIOS that acpi routing is working, but mptable is not right.
> >>    so can use kernel/kexec to start other os that doesn't have good acpi support
> >
> > Is this an effort to boot an ACPI-mode kernel,
> > and then kexec a non-ACPI kernel?
> 
> Yes,

Why is this feature needed?
There are a number of ways that the resulting kernel may fail,
all platform specific.

> >
> > Doing so could confuse the heck out of the platform firmware,
> > which will think that an ACPI-mode kernel is still running.
> >
> > Note that it is a historic artifact, now considered a bug,
> > that ACPI uses the MPS code.  We should be divorcing these
> > two bodies of code rather than mixing them further.
> 
> how about adding config option to not compile mptable related info?

That's the idea.
CONFIG_MPS=n CONFIG_ACPI=y should build and run on
every PC built in this century.

This was prototyped a long while back, but the
tree has churned so much since then the old
prototype is worthless.

-Len

