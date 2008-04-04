Return-Path: <linux-kernel-owner+w=401wt.eu-S1757745AbYDDC1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745AbYDDC1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 22:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYDDC1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 22:27:13 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:21916 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYDDC1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 22:27:12 -0400
Date: Thu, 03 Apr 2008 20:25:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Slow tape drive timeout
In-reply-to: <alpine.LSU.1.10.0804032121380.9918@kai.makisara.local>
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Carlo Nyto <carlonyto@gmail.com>, linux-kernel@vger.kernel.org
Message-id: <47F5917C.5080803@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.iY7vJs54MoScDgyQ4PUWZsO+3Jw@ifi.uio.no>
 <fa.of3hIrxfNefAS08Tzqfm1dI0BOo@ifi.uio.no> <47F45B39.7080305@shaw.ca>
 <alpine.LSU.1.10.0804032121380.9918@kai.makisara.local>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kai Makisara wrote:
> On Wed, 2 Apr 2008, Robert Hancock wrote:
> 
>> Kai Makisara wrote:
>>> On Tue, 1 Apr 2008, Carlo Nyto wrote:
>>>
>>>> I am experiencing a two minute timeout open()ing a tape device when
>>>> there is no tape in the drive.
>>>>
>>>> open() with O_NONBLOCK succeeds immediately, however.
>>>>
>>> This is how open() is supposed to work according to standards (e.g., SUS) if
>>> O_NONBLOCK is supported. (Well, actually open() should wait indefinitely but
>>> the non-linux systems I tested had a timeout.) The linux st driver was
>>> changed to comply with standards at 2.5.3. I.e., the 2.4 kernels did return
>>> immediately but the 2.6 kernels have always waited.
>>>
> ...
>> Why is accessing the tape drive with no tape in it causing a timeout in the
>> first place? I should think that would fail immediately with some "medium not
>> present" error from the drive. Unless the drive has no mechanism to detect it,
>> but that seems really retarded..
>>
> It does not seem retarded to me. If a program wants to just wait until the 
> tape drive becomes ready (e.g., loads the tape), it can use the blocking 
> open. This is simple. If a program wants to test the status, it uses 
> non-blocking open. The behavior mandated by the standards provides 
> alternatives. If O_NONBLOCK is not supported, the user program must 
> implement the waiting logic if the program just wants to wait until the 
> drive is ready before starting i/o.

This behavior is not consistent with any other removable storage device 
provided by Linux, however. If you try to open a CD-ROM device node when 
no disc is inserted, it doesn't block, it just gives you an error right 
away. Why should the tape drive behavior be different?
