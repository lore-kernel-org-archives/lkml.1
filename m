Return-Path: <linux-kernel-owner+w=401wt.eu-S932642AbXHOWAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642AbXHOWAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbXHOV76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 17:59:58 -0400
Received: from 207.47.60.147.static.nextweb.net ([207.47.60.147]:58059 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbXHOV75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 17:59:57 -0400
X-Greylist: delayed 976 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2007 17:59:57 EDT
Message-ID: <46C372DD.6070405@xensource.com>
Date: Wed, 15 Aug 2007 14:40:45 -0700
From: Jeremy Fitzhardinge <jeremy@xensource.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: Andi Kleen <ak@suse.de>, lguest@ozlabs.org, shai@scalemp.com,
       kiran@scalemp.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, chrisw@sous-sol.org,
       anthony@codemonkey.ws, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
References: <11871821854176-git-send-email-gcosta@redhat.com>	<1187182197314-git-send-email-gcosta@redhat.com>	<11871822062386-git-send-email-gcosta@redhat.com>	<11871822163867-git-send-email-gcosta@redhat.com>	<20070815135554.GE3406@bingen.suse.de>	<5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com>	<20070815154243.GH3406@bingen.suse.de>	<46C31736.2050001@redhat.com>	<20070815163640.GJ3406@bingen.suse.de> <46C3283B.5090804@redhat.com>
In-Reply-To: <46C3283B.5090804@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Aug 2007 21:43:39.0515 (UTC) FILETIME=[57824CB0:01C7DF85]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> Thanks for the explanation, Andi. I understand it much better now, and
> agree with you.
>
> As alternatives what we have now, we can either keep the paravirt_ops
> as it is now for the native case, just hooking the vsmp functions in
> place of the normal one, (there are just three ops anyway), refill the
> paravirt_ops entirely in somewhere like vsmp.c, or similar (or maybe
> even assigning paravirt_ops.fn = vsmp_fn on the fly, but early enough). 

One thing to note is that current code assumes the IF flag is always in
bit 9, so if you paravirtualize this, you need to either a) make the
vsmp version copy AC into IF to satisfy the interface, or b) add a new
op meaning "tell me if this eflags has interrupts enabled or not".  I
went for option a), and it seems to work OK (using bit 9 for "interrupt
enabled" is pretty arbitrary from a Xen perspective, but not very hard
to implement, and more localized than making all eflags tests a pvop).

    J
