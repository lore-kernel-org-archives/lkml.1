Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbZCOAc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbZCOAc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 20:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZCOAcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 20:32:48 -0400
Received: from gw.goop.org ([64.81.55.164]:56354 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZCOAcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 20:32:47 -0400
Message-ID: <49BC4CAC.202@goop.org>
Date: Sat, 14 Mar 2009 17:32:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com>
In-Reply-To: <49BC413B.5020104@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hi guys,
>
> I was reviewing the latest brk patchset, and I have a question:
>
> Why is the brk merged into the .bss, instead of being left in its own
> (nobits) segment:
>
>   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
> 	__init_end = .;
> 	__bss_start = .;		/* BSS */
> 	*(.bss.page_aligned)
> 	*(.bss)
> 	. = ALIGN(4);
> 	__bss_stop = .;
>
> 	. = ALIGN(PAGE_SIZE);
> 	__brk_base = . ;
> 	. += 64 * 1024 ;	/* 64k slop space */
> 	*(.brk_reservation)	/* areas brk users have reserved */
> 	__brk_limit = . ;
>
>   	_end = . ;
>   }
>
> It really doesn't make much sense to me, and is more than a bit
> confusing given the symbols.
>   

Mostly because I knew that the bss would get mapped into the appropriate 
phdr segment correctly, but I wasn't sure that another bss-like section 
would be.  Also because historically the brk segment was just an 
extension of the executable's bss, and its more or less the same too.

Is there any real benefit in putting it into another section?

    J
