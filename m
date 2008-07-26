Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbYGZQuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbYGZQuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 12:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYGZQt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 12:49:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60905 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYGZQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 12:49:57 -0400
Message-ID: <488B555F.4090709@zytor.com>
Date: Sat, 26 Jul 2008 12:48:31 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Olaf Hering <olaf@aepfle.de>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fw: asm-x86/byteorder.h, CONFIG_X86_BSWAP leaks to userland
References: <20080726013931.bcc4682d.akpm@linux-foundation.org> <1217090446.5971.57.camel@brick>
In-Reply-To: <1217090446.5971.57.camel@brick>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
>>
>> An undefined CONFIG_foo defaults to 0 (I think), so bswap is never used.
>> Is this done on purpose, or can the CONFIG_ foo be moved inside
>> __KERNEL__ somehow?
> 
> I believe it's there to prevent the bswap instruction from being used on
> early x86_32 models (i386/i486).  As this will be 0 in userspace it is
> effectively never using the bswap instruction for these routines.
> 

i386, specifically.

However, you shouldn't leak these symbols to userspace; there is a 
warning option in gcc for undefined macros, and it's a *good thing* to 
use it.  Causing warnings in user space is not nice.

> I'm not sure if it's time yet to make the bswap ones be exported, as they
> would no longer be usable for those early machines.  X86 guys CC:d.

On i386 we still default to i386-compatible binaries; I *think* gcc has 
macros telling you if the user has used -march=i486 etc.

	-hpa
