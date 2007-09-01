Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbXIABx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbXIABx4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 21:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXIABtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 21:49:25 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:8586 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbXIABtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 21:49:23 -0400
Date: Fri, 31 Aug 2007 19:48:12 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Copy large memory regions from & to userspace
In-reply-to: <fa.tMlh7ZYvNMxPEL69Eww8ErwDEmw@ifi.uio.no>
To: Clemens Kolbitsch <clemens.kol@gmx.at>
Cc: Chris Smith <smitty1elkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Message-id: <46D8C4DC.2080307@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.0TqRgC3Smn96vb+Bwv5QRWKBTQg@ifi.uio.no>
 <fa.x2L04usZZxVIMYSdrufu+Hen9aY@ifi.uio.no>
 <fa.tMlh7ZYvNMxPEL69Eww8ErwDEmw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Kolbitsch wrote:
> On Friday 31 August 2007 15:25:40 you wrote:
>> On 8/30/07, Clemens Kolbitsch <clemens.kol@gmx.at> wrote:
>>> Hi!
>>> Just a short question: What is the correct method of copying large areas
>>> of memory from userspace into userspace when running in kernel-mode?
>> relayfs?
> 
> no... I'm copying user-memory to user-memory, not kernel-to-user, however 
> running the code in kernel-mode.
> 
> what i wanted to know is how to check the access-rights...
> i didn't get any other answers, so for now i'm just using 
> 
> if (access_ok(VERIFY_READ, from, PAGE_SIZE) &&
>     access_ok(VERIFY_WRITE, to, PAGE_SIZE))
> {
>     memcpy(to, from, PAGE_SIZE);
> }
> 
> and hope that this is the *correct* way to do it...

No, it's not. access_ok does not guarantee that the memory region can be 
validly read or written. It only allows using __copy_to_user or 
__copy_from_user which skips the same checks that access_ok does.

I'm not aware of any code in the kernel that does userspace-to-userspace 
copies directly. Likely because there's rarely a need for it?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

