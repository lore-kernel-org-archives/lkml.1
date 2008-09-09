Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYIIOrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYIIOrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 10:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYIIOrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 10:47:10 -0400
Received: from gw.goop.org ([64.81.55.164]:50548 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbYIIOrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 10:47:09 -0400
Message-ID: <48C68C6B.7030803@goop.org>
Date: Tue, 09 Sep 2008 07:47:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag for IO mappings
References: <4d93ba619c716c45cca0.1220826073@localhost> <48C67AE0.5060503@qumranet.com>
In-Reply-To: <48C67AE0.5060503@qumranet.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Jeremy Fitzhardinge wrote:
>> Use one of the software-defined PTE bits to indicate that a mapping is
>> intended for an IO address.  On native hardware this is irrelevent,
>> since a physical address is a physical address.  But in a virtual
>> environment, physical addresses are also virtualized, so there needs
>> to be some way to distinguish between pseudo-physical addresses and
>> actual hardware addresses; _PAGE_IOMAP indicates this intent.
>>
>> By default, __supported_pte_mask masks out _PAGE_IOMAP, so it doesn't
>> even appear in the final pagetable.
>>   
>
> Could PTE_SPECIAL, added for get_user_pages_really_fast(), be reused
> for this?
>

I'm not sure; I still don't really understand how _PAGE_SPECIAL gets
used, other than being user-mode mapping only.  But in principle,
_PAGE_IOMAP could be set on both kernel and user mappings (if you direct
map a device into a process address space), so I think they would
conflict then?

Also, _PAGE_SPECIAL is also shared with _PAGE_CPA_TEST, which is only
used on kernel mappings, so they can co-exist happily.

Is _PAGE_IOMAP at all useful for device passthrough in kvm?

    J
