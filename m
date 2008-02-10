Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYBJRQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYBJRQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 12:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbYBJRQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 12:16:03 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:46140 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbYBJRQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 12:16:01 -0500
Message-ID: <47AF314C.9090104@lwfinger.net>
Date: Sun, 10 Feb 2008 10:15:56 -0700
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Query about set_pages_* API
References: <47AE2BCC.3040605@lwfinger.net> <20080209160040.088b99a6@laptopd505.fenrus.org>
In-Reply-To: <20080209160040.088b99a6@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Sat, 09 Feb 2008 15:40:12 -0700
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> Is the set_pages_* API that replaces change_page_attr described
>> somewhere? I have been unable to find it with Google.
>>
>> I'm trying to modify the VirtualBox kernel module to work with
>> 2.6.24-git (and 2.6.25) on x86_64 architecture. The current code has
>> a value of the third argument of the call (prot) with 3 variants. All
>> variations have the following bits set: _PAGE_PRESENT, _PAGE_RW,
>> _PAGE_DIRTY, and _PAGE_ACCESSED. Number 2 adds _PAGE_NX to the above,
>> and number 3 adds _PAGE_GLOBAL to the bits in variation 1.
>>
>>  From the code in arch/x86/mm/pageattr.c, I figured I need to call
>> set_pages_wb() unconditionally, and set_pages_nx() if _PAGE_NX is
>> set. Will these calls be sufficient? I thought about calling
>> set_pages_rw(), but that entry is not exported.
>>
> 
> ok looking at the actual code.. it seems to only care about making a piece of memory executable 
> (and then clearing it before freeing), so all you need is set_memory_x() and set_memory_nx()

Thanks for the response. It is working now.

Larry
