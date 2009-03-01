Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbZCASIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbZCASIT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 13:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756890AbZCASIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 13:08:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:38173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932AbZCASIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 13:08:10 -0500
Message-ID: <49AACEB3.5050206@kernel.org>
Date: Sun, 01 Mar 2009 10:06:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] x86: put initial_pg_tables into bss -v2
References: <1235785882-17580-1-git-send-email-jeremy@goop.org> <1235785882-17580-4-git-send-email-jeremy@goop.org> <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com> <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu> <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org> <49A8F319.3030802@goop.org> <49A9E392.6090004@kernel.org> <49AA47D2.4020804@kernel.org> <49AA5356.3050602@zytor.com>
In-Reply-To: <49AA5356.3050602@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>> Impact: cleanup
>>
>> Don't use ram after _end blindly for pagetables.
>> put those pg table into bss
>>
>> also remove init_pg_tables_start/end tricks all around
>>
>> v2: keep initial page table up to 512M only.
...

> 
> No, this is garbage.  If you're insisting on getting rid of the brk-like
> allocation patterns, then you have to get an alternative dynamic
> allocator available to the pre-paging code.  Now, there is no reason we
> couldn't execute C code before enabling paging, although the code would
> either have to be PIC or linked at the physical address.

you can use find_e820_area()/reserve_early() pair to find right position for that.

YH
