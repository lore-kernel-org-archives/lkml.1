Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbYL0VQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbYL0VQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 16:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYL0VQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 16:16:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51775 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYL0VQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 16:16:07 -0500
Message-ID: <49569AF1.8050205@zytor.com>
Date: Sat, 27 Dec 2008 13:15:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, Mike Frysinger <vapier@gentoo.org>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <20081227071208.GB27736@uranus.ravnborg.org> <20081227084708.GA16077@elte.hu>
In-Reply-To: <20081227084708.GA16077@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
>> On Sat, Dec 27, 2008 at 01:50:04AM -0500, Mike Frysinger wrote:
>>> Use __asm__/__inline__ rather than asm/inline for all the functions
>>> exported to userspace.
>> I will imagine that we will see cleanup patches converting
>> these back to inline/asm.
>> How about doing this conversion as part of the headers_install.pl
>> script so we know it is always correct?
>>
>> Then we can keep the familiar inline/asm in the kernel headers
>> and always use the correct __asm__, __inline__ version for our
>> exported headers.
> 
> or name it __asm__exported__ to make sure it isnt cleaned up away.
> 

Seems better to do it automatically.  We end up with cleaner-looking
code that way, too.

It doesn't solve the need for symbols in inline functions in exported
headers to have __ prefixes, though.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

