Return-Path: <linux-kernel-owner+w=401wt.eu-S935276AbYBGWfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935276AbYBGWfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935154AbYBGWfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:35:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935149AbYBGWfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:35:04 -0500
Message-ID: <47AB8772.4010709@zytor.com>
Date: Thu, 07 Feb 2008 14:34:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>
Subject: Re: [rft] s2ram wakeup moves to .c, could fix few machines
References: <20080205190600.GB11613@elf.ucw.cz> <200802060227.14385.rjw@sisk.pl> <200802070049.00461.rjw@sisk.pl> <200802072312.31430.rjw@sisk.pl> <20080207222833.GA23004@uranus.ravnborg.org>
In-Reply-To: <20080207222833.GA23004@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> +
>> +	. = 0;
>> +	.text		: { *(.text*) }
>> +
>> +	. = ALIGN(16);
> Why?

It's good practice to have at least paragraph (segment boundary) 
alignment between different types of data.  In the case of the .bss, it 
also allows cleaning with rep;movsl.

It's technically not all that necessary (except for 4-byte alignment for 
the .bss), but it makes things easier to debug on the assembly level.

>> +	/* Adjust this as appropriate */
>> +	/* This allows 4 pages (16K) */
>> +	. = ASSERT(_end <= 0x4000, "Wakeup too big!");
> PAGE_SIZE * 4?

Not really, because it's not at all related to the kernel page size; the 
reference to pages there is informal.  If we go to a larger virtual page 
size we do NOT want this to change.

	-hpa
