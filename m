Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbXI1NKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbXI1NKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 09:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752521AbXI1NKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 09:10:05 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:3844 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbXI1NKD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 09:10:03 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 28 Sep 2007 13:09:47.0152 (UTC) FILETIME=[D82A1100:01C801D0]
Content-class: urn:content-classes:message
Subject: Re: Out of memory management in embedded systems
Date: Fri, 28 Sep 2007 09:09:36 -0400
Message-ID: <Pine.LNX.4.61.0709280857520.8940@chaos.analogic.com>
In-Reply-To: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Out of memory management in embedded systems
Thread-Index: AcgB0NgzPs/orChbToeYeAUzzJQphg==
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: =?iso-8859-1?Q?Daniel_Sp=E5ng?= <daniel.spang@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 28 Sep 2007, [iso-8859-1] Daniel Spång wrote:

> Applications with dynamic input and dynamic memory usage have some
> issues with the current overcommitting kernel. A high memory usage
> situation eventually results in that a process is killed by the OOM
> killer. This is especially evident in swapless embedded systems with
> limited memory and no swap available.
>
> Some kind of notification to the application that the available memory
> is scarce and let the application free up some memory (e.g., by
> flushing caches), could be used to improve the situation and avoid the
> OOM killer. I am currently not aware of any general solution to this
> problem, but I have found some approaches that might (or might not)
> work:
>
> o Turn off overcommit. Results in a waste of memory.
>
> o Nokia uses a lowmem security module to signal on predetermined
> thresholds. Currently available in the -omap tree. But this requires
> manual tuning of the thresholds.
> http://www.linuxjournal.com/article/8502
>
> o Using madvise() with MADV_FREE to get the kernel to free mmaped
> memory, typically application caches, when the kernel needs the
> memory.
>
> o A OOM handler that the application registers with the kernel, and
> that the kernel executes before the OOM-killer steps in.
>
> Does it exist any other solutions to this problem?
>
> Daniel
> -

But an embedded system contains all the software that will
ever be executed on that system! If it is properly designed,
it can never run out of memory because everything it will
ever do is known at design time.

This should never be an issue with an embedded system.
If you have such a system issue, then you have
application(s) that have memory leaks because of
improper design or coding. For instance, there is
a common open-source web-server that is used in some
embedded systems. It has memory leaks. The solution,
if the server can't be fixed, is to execute a supervisor
process which periodically shuts it down and restarts
it --ugly, but effective if the developers refuse to
accept patches.

You shouldn't expect a kernel to be modified to "fix"
broken application code.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_

****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
