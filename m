Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbZBSG35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbZBSG35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 01:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZBSG3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 01:29:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:33358 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751796AbZBSG3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 01:29:47 -0500
Message-ID: <499CFC63.2070608@kernel.org>
Date: Thu, 19 Feb 2009 15:29:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Serguei Miridonov <mirsev@cicese.mx>
CC: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Intel ICH9M/M-E SATA error-handling/reset problems
References: <200902141206.06419.mirsev@cicese.mx> <4998593D.2050300@gmail.com> <4998CB34.6090300@kernel.org> <200902160817.16614.mirsev@cicese.mx>
In-Reply-To: <200902160817.16614.mirsev@cicese.mx>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 19 Feb 2009 06:29:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Serguei.

Serguei Miridonov wrote:
>>>> I agree with you completely. Nevertheless, something like 10
>>>> errors per 2GB transfer can not be the reason to give up. Vista,
>>>> at least, recovers and continues the data transfer. Linux simply
>>>> can not return the interface or connected device into operating
>>>> mode. Do you think it is normal?
>> Well, there isn't much point in keeping retrying if the same
>> command fails consecutively. 
> 
> I'm not talking about the _same_ transfer command. I mean intermittent 
> errors, average 10 parity errors per 2GB file. Let me repeat myself 
> from another post:
> 
> ... my very strong opinion based just on general physics is that 
> error rate on SATA can be (and will be) much higher than that one on 
> PATA. PATA operates at lower frequencies and cables are much shorter. 
> eSATA cables are longer and work at up to 3Gb/s. Moreover, consider 
> all these consumer-grade connectors, cables, etc. So, CRC errors could 
> be quite common and software needs to handle them properly to keep 
> transfers fast and maintain the communication with a device.

The kernel doesn't give up after intermittent errors.

> And, remember USB bulk transfer? Who is taking care on CRC check and 
> retries there?

What you're describing is already handled.  No need to worry about it.

>> The problem was the broken speed down
>> logic, so all the retries failed and FS eventually received IO
>> failure.  Should have been fixed with recent changes.
> 
> Slow down may help to reduce amount of errors but it may happen that 
> they can not be avoided completely.
> 
>> In the log, ata2.00 went down after a timeout.  The reset per-se
>> isn't the problem and is the RTTD after a timeout as the controller
>> and device states are unknown.  The situations like yours in the
>> log often happens because an ATAPI device shuts down completely
>> after certain transmission problems.  When this happens, there's
>> nothing much the driver can do and soft reboot wouldn't recover the
>> device either.
> 
> So, this is the kernel job to keep things working, not break them :-)

Yeah, and other than the hardware quirkiness on your machine, it
already works fine.

>> But seeing you're on dv5, I think you might be experiencing
>> something else.  Please take a look at the following bz.
>>
>>   http://bugzilla.kernel.org/show_bug.cgi?id=12276
> 
> Yes, I tried to suspend to RAM and when the laptop waked up it failed 
> to communicate with the hard drive. So, I use hibernate instead.

Can you please try to take a look at the kernel log after the kernel
resumes and see whether you're actually seeing the same problem?

Thanks.

-- 
tejun
