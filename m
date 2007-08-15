Return-Path: <linux-kernel-owner+w=401wt.eu-S935631AbXHOWTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935631AbXHOWTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 18:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbXHOWTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 18:19:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758790AbXHOWTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 18:19:30 -0400
Message-ID: <46C37BF6.50909@redhat.com>
Date: Wed, 15 Aug 2007 19:19:34 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Andi Kleen <ak@suse.de>, lguest@ozlabs.org, shai@scalemp.com,
       kiran@scalemp.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, chrisw@sous-sol.org,
       anthony@codemonkey.ws, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 3/25][V3] irq_flags / halt routines
References: <11871821854176-git-send-email-gcosta@redhat.com>	<1187182197314-git-send-email-gcosta@redhat.com>	<11871822062386-git-send-email-gcosta@redhat.com>	<11871822163867-git-send-email-gcosta@redhat.com>	<20070815135554.GE3406@bingen.suse.de>	<5d6222a80708150718v14f26343q7467385e7919fa76@mail.gmail.com>	<20070815154243.GH3406@bingen.suse.de>	<46C31736.2050001@redhat.com>	<20070815163640.GJ3406@bingen.suse.de> <46C3283B.5090804@redhat.com> <46C372DD.6070405@xensource.com>
In-Reply-To: <46C372DD.6070405@xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge escreveu:
> Glauber de Oliveira Costa wrote:
>> Thanks for the explanation, Andi. I understand it much better now, and
>> agree with you.
>>
>> As alternatives what we have now, we can either keep the paravirt_ops
>> as it is now for the native case, just hooking the vsmp functions in
>> place of the normal one, (there are just three ops anyway), refill the
>> paravirt_ops entirely in somewhere like vsmp.c, or similar (or maybe
>> even assigning paravirt_ops.fn = vsmp_fn on the fly, but early enough). 
> 
> One thing to note is that current code assumes the IF flag is always in
> bit 9, so if you paravirtualize this, you need to either a) make the
> vsmp version copy AC into IF to satisfy the interface, or b) add a new
> op meaning "tell me if this eflags has interrupts enabled or not".  I
> went for option a), and it seems to work OK (using bit 9 for "interrupt
> enabled" is pretty arbitrary from a Xen perspective, but not very hard
> to implement, and more localized than making all eflags tests a pvop).
> 
>     J
It is implemented like a) in the latest patch I send, following chris' 
suggestion.
