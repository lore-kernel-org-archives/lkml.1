Return-Path: <linux-kernel-owner+w=401wt.eu-S1946051AbXBPTC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946051AbXBPTC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 14:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946050AbXBPTC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 14:02:27 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37927 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946043AbXBPTC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 14:02:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
	<45D5F2EC.5000402@goop.org>
Date: Fri, 16 Feb 2007 12:01:43 -0700
In-Reply-To: <45D5F2EC.5000402@goop.org> (Jeremy Fitzhardinge's message of
	"Fri, 16 Feb 2007 10:07:40 -0800")
Message-ID: <m1ps8ac4fc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> So I propose we remove all assumptions from the code that we actually
>> have an array of irqs.  That will allow for irq_desc to be dynamically
>> allocated instead of statically allocated saving memory and reducing
>> kernel complexity.
>>   
>
> Sounds good to me.  In Xen we have 1024 event channels which we need to
> map down into a smaller irq.  Aside from the complexity of maintaining a
> mapping table, that's not a huge issue for now, but when we start
> exposing pci devices to guests it all becomes more complex.  The ideal
> for us is to simply use event channel == irq, which this would allow.

Well you shouldn't need to wait just run with a kernel with NR_IRQS >= 1024.
1024 is stretch but it isn't to bad.  There are already x86 boxes that have
more pins on their ioapics then that. So x86_64 and with this latest
round of patches from Len Brown and I i386 should be able to support that.

On the other side 1024 looks extremely limiting for exposing pci devices.  
If someone gets serious about pushing what is legal with MSI-X you may be
in trouble.  As a single device is allowed to have 4096 interrupts.   Not
that I can think of a user for so many but...

Eric
