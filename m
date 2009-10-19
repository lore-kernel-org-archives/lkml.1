Return-Path: <linux-kernel-owner+w=401wt.eu-S1756232AbZJSN66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232AbZJSN66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 09:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbZJSN65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 09:58:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37077 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755618AbZJSN65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 09:58:57 -0400
Date: Mon, 19 Oct 2009 09:59:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Contreras <felipe.contreras@gmail.com>
cc: Jiri Kosina <jkosina@suse.cz>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Sarah Sharp <sarah.a.sharp@linux.intel.com>,
       <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/7] usb: trivial cleanups
In-Reply-To: <94a0d4530910181609u33955cd5tf9e56b7d2ae9a616@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0910190956580.3899-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Oct 2009, Felipe Contreras wrote:

> I still have an unfixed warning:
> drivers/usb/core/hcd.c: In function ‘rh_string’:
> /data/public/src/linux/arch/x86/include/asm/string_32.h:74: warning:
> array subscript is above array bounds
> 
> Apparently there's a problem with the optimized memcpy for x86 with this code:
> static char const langids[4] = {4, USB_DT_STRING, 0x09, 0x04};
> len = min_t(unsigned, len, sizeof(langids));
> memcpy(data, langids, len);
> return len;
> 
> gcc 4.4 is trying to optimize the memcpy, but it's not able to realize
> that 'len' will always be <= 4 and the memcpy will not exceed langids.
> One way to solve this is by replacing len with the min_t expression:
> memcpy(data, langids, min_t(unsigned, len, sizeof(langids)));
> 
> However, that looks ugly and we need the expression again for the
> return. Another way is to remove 'const' from langids.
> 
> AFAIK the code is perfectly correct as it is, I think the fact that
> gcc 4.4 complains is a bug on gcc side.

Yes, it is a well-known bug in gcc.  Other places in the kernel get 
similar warnings.

Alan Stern

