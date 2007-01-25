Return-Path: <linux-kernel-owner+w=401wt.eu-S965537AbXAYGaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537AbXAYGaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 01:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965535AbXAYGaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 01:30:46 -0500
Received: from terminus.zytor.com ([192.83.249.54]:37784 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965517AbXAYGap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 01:30:45 -0500
Message-ID: <45B84E84.1080004@zytor.com>
Date: Wed, 24 Jan 2007 22:30:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: andersen@codepoet.org, Mike Frysinger <vapier.adi@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       viro@zeniv.linux.org.uk, Alexey Dobriyan <adobriyan@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [patch] scrub non-__GLIBC__ checks in linux/socket.h and linux/stat.h
References: <8bd0f97a0612161042g3b61d42csd54cae46e4864f30@mail.gmail.com> <20061216185726.GA17496@codepoet.org>
In-Reply-To: <20061216185726.GA17496@codepoet.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Erik Andersen wrote:
> On Sat Dec 16, 2006 at 01:42:11PM -0500, Mike Frysinger wrote:
>> On 11/30/06, Robert P. J. Day <rpjday@mindspring.com> wrote:
>>> but there are a few other
>>> cases which still contain compound preprocessor directives such as:
>>>
>>>  #if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
>>>
>>> having never worked with unifdef before, i guess i was being overly
>>> optimistic in thinking that it, if i "unifdef"ed __KERNEL__, it might
>>> at least simplify the expression.  oh, well ... live and learn.
>> userspace should be worrying about userspace, so having the socket.h
>> and stat.h pollute the namespace in the non-glibc case is wrong and
>> pretty much prevents any other libc from utilizing these headers
>> sanely unless they set up the __GLIBC__ define themselves (which
>> sucks)
>> -mike
> 
> Ack from me.  I'd love to see this applied so uClibc could
> stop have to define __GLIBC__
> 

klibc uses these definitions, but the right thing to do is to have libc 
ask for it:

#if defined(__KERNEL__) || defined(__EXPORT_LINUX_SOCKET_H)

/* ... */

#endif

That way, klibc can just

#define __EXPORT_LINUX_SOCKET_H
#include <linux/socket.h>

	-hpa
