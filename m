Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbYIINc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbYIINc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 09:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYIINcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 09:32:18 -0400
Received: from il.qumranet.com ([212.179.150.194]:37235 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYIINcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 09:32:17 -0400
Message-ID: <48C67AE0.5060503@qumranet.com>
Date: Tue, 09 Sep 2008 16:32:16 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag for IO mappings
References: <4d93ba619c716c45cca0.1220826073@localhost>
In-Reply-To: <4d93ba619c716c45cca0.1220826073@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Use one of the software-defined PTE bits to indicate that a mapping is
> intended for an IO address.  On native hardware this is irrelevent,
> since a physical address is a physical address.  But in a virtual
> environment, physical addresses are also virtualized, so there needs
> to be some way to distinguish between pseudo-physical addresses and
> actual hardware addresses; _PAGE_IOMAP indicates this intent.
>
> By default, __supported_pte_mask masks out _PAGE_IOMAP, so it doesn't
> even appear in the final pagetable.
>   

Could PTE_SPECIAL, added for get_user_pages_really_fast(), be reused for 
this?

-- 
error compiling committee.c: too many arguments to function

