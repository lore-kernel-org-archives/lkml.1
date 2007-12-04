Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbXLDVbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbXLDVbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbXLDVbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:31:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:56681 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbXLDVbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:31:04 -0500
Date: Tue, 4 Dec 2007 20:34:32 +0100
From: Andi Kleen <ak@suse.de>
To: Avi Kivity <avi@qumranet.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       ehabkost@redhat.com, jeremy@goop.org, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com
Subject: Re: [PATCH 4/8] unify paravirt parts of system.h
Message-ID: <20071204193432.GI11764@bingen.suse.de>
References: <11967843881946-git-send-email-gcosta@redhat.com> <11967843943958-git-send-email-gcosta@redhat.com> <11967843983411-git-send-email-gcosta@redhat.com> <11967844032081-git-send-email-gcosta@redhat.com> <11967844071346-git-send-email-gcosta@redhat.com> <4755A809.4050305@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4755A809.4050305@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 09:18:33PM +0200, Avi Kivity wrote:
> Glauber de Oliveira Costa wrote:
>> This patch moves the i386 control registers manipulation functions,
>> wbinvd, and clts functions to system.h. They are essentially the same
>> as in x86_64, except for the cr8 register, which we add.
>>
>> +
>> +static inline unsigned long native_read_cr8(void)
>> +{
>> +	unsigned long cr8;
>> +	asm volatile("mov %%cr8,%0" : "=r" (cr8), "=m" (__force_order));
>> +	return cr8;
>> +}
>> +
>>   
>
> There is no cr8 register on i386.  This had better be protected by an 
> #ifdef.
>
> (you're likely not getting an error since it's a static inline, so the asm 
> is never emitted)

Linux never uses that register. The only user is suspend save/restore, 
but that' bogus because it wasn't ever initialized by Linux in the first
place. It could be probably all safely removed.

-Andi

