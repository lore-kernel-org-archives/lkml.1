Return-Path: <linux-kernel-owner+w=401wt.eu-S968262AbXJSWDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968262AbXJSWDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968173AbXJSWDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:03:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:42240 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968077AbXJSWDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:03:09 -0400
Message-ID: <47192999.6010607@garzik.org>
Date: Fri, 19 Oct 2007 18:03:05 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.23] tasks stuck in running state?
References: <47192425.6020507@garzik.org> <47192763.9050004@redhat.com>
In-Reply-To: <47192763.9050004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 10/19/2007 05:39 PM, Jeff Garzik wrote:
>> On my main devel box, vanilla 2.6.23 on x86-64/Fedora-7, I'm seeing a
>> certain behavior at least once a day.  I'll start a kernel build (make
>> -sj5 on this box), and it will "hang" in the following way:
>>
> 
> Can you try to strace the hanging task?

Well, to the system it's running, so that doesn't do much of anything...

> 
>  8482 pts/0    S+     0:00                          \_ /bin/sh /garz/repo/misc-2.6/scripts/hdrcheck.sh /garz/repo/misc-2.6/usr/include /garz/repo/misc-2.6/usr/include/linux/kernelcapi.h /garz/repo/misc-2.6/usr/include/linux/.check.kernelcapi.h
>  8484 pts/0    R+     3:10                              \_ grep ^[ \t]*#[ \t]*include[ \t]*< /garz/repo/misc-2.6/usr/include/linux/kernelcapi.h
>  8486 pts/0    S+     0:00                              \_ cut -f2 -d<
>  8487 pts/0    S+     0:00                              \_ cut -f1 -d>
>  8488 pts/0    S+     0:00                              \_ egrep ^linux|^asm
> [jgarzik@pretzel misc-2.6]$ strace -p8484
> Process 8484 attached - interrupt to quit
[sits there, chewing up CPU grepping a 47-line header file]
