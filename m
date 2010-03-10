Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab0CJWS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 17:18:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:52436 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0CJWSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 17:18:55 -0500
Message-ID: <4B981AC2.90201@windriver.com>
Date: Wed, 10 Mar 2010 16:18:42 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 4/6] usb-serial: optimize sysrq function calls
References: <Pine.LNX.4.44L0.1003091008070.1693-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003091008070.1693-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2010 22:18:43.0304 (UTC) FILETIME=[A4F08680:01CAC09F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 9 Mar 2010, Jason Wessel wrote:
>
>   
>> There is no need to have external function calls for the sysrq
>> functions.  The compiler can inline the sysrq calls such that they are
>> entirely a NOP if CONFIG_MAGIC_SYSRQ is not set.
>>     
>
> This is not the best way to do what you want.  Keep 
> usb_serial_handle_sysrq_char() and usb_serial_handle_break() as 
> out-of-line routines in generic.c, but make them conditional on 
> CONFIG_MAGIC_SYSRQ.  Then in the header file, depending on whether or 
> not CONFIG_MAGIC_SYSRQ is defined, either put the usual extern function 
> declarations or else put do-nothing inline definitions.
>
> The advantage of keeping the functions out-of-line is the reduced
> amount of code space (since the bodies aren't replicated every place
> they get used).  This way you keep that advantage while still getting
> the NOP implementation if CONFIG_MAGIC_SYSRQ isn't set.
>   

It is probably fine to just drop this patch entirely then.

I had originally made the change to keep it similar to the uart based
serial drivers where the definitions are inlined.

Jason.
