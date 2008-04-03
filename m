Return-Path: <linux-kernel-owner+w=401wt.eu-S1761238AbYDCEYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238AbYDCEYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 00:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYDCEYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 00:24:39 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:46063 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbYDCEYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 00:24:17 -0400
Date: Wed, 02 Apr 2008 22:21:13 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Slow tape drive timeout
In-reply-to: <fa.of3hIrxfNefAS08Tzqfm1dI0BOo@ifi.uio.no>
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Carlo Nyto <carlonyto@gmail.com>, linux-kernel@vger.kernel.org
Message-id: <47F45B39.7080305@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.iY7vJs54MoScDgyQ4PUWZsO+3Jw@ifi.uio.no>
 <fa.of3hIrxfNefAS08Tzqfm1dI0BOo@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kai Makisara wrote:
> On Tue, 1 Apr 2008, Carlo Nyto wrote:
> 
>> I am experiencing a two minute timeout open()ing a tape device when
>> there is no tape in the drive.
>>
>> open() with O_NONBLOCK succeeds immediately, however.
>>
> This is how open() is supposed to work according to standards (e.g., SUS) 
> if O_NONBLOCK is supported. (Well, actually open() should wait 
> indefinitely but the non-linux systems I tested had a timeout.) The linux 
> st driver was changed to comply with standards at 2.5.3. I.e., the 2.4 
> kernels did return immediately but the 2.6 kernels have always waited.
> 
>> The problem is that I am trying to set up Legato on a system that has
>> multiple tape drives. For certain common operations, Legato tries to
>> open() each tape drive multiple times. On a system with multiple tape
>> drives, this adds up to a significant amount of time wasted due to
>> this timeout.
>>
> You are not the only person who has noticed this. At work we had to 
> install a distribution using 2.4 kernel to our backup server in order to 
> use Legato ;-(
> 
> But this is a Legato problem, not a kernel problem.
> 
>> Solaris does not have this problem, and Legato support advises that
>> they are at the mercy of the operating system.
>>
> Solaris does return EIO. Either it does not support O_NONBLOCK or it is 
> not compliant with SUS.
> 
> Legato would not be so much "at the mercy of the operating system" if they 
> would write their software to work according to standards, not according 
> to some operating system.

Why is accessing the tape drive with no tape in it causing a timeout in 
the first place? I should think that would fail immediately with some 
"medium not present" error from the drive. Unless the drive has no 
mechanism to detect it, but that seems really retarded..
