Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbXHXLfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbXHXLfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 07:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754318AbXHXLey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 07:34:54 -0400
Received: from spirit.analogic.com ([204.178.40.4]:1931 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbXHXLex convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 07:34:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 24 Aug 2007 11:34:45.0500 (UTC) FILETIME=[C541C3C0:01C7E642]
Content-class: urn:content-classes:message
Subject: Re: division and cpu usage
Date: Fri, 24 Aug 2007 07:34:50 -0400
Message-ID: <Pine.LNX.4.61.0708240731130.8096@chaos.analogic.com>
In-Reply-To: <46CE1BA2.8070200@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: division and cpu usage
Thread-Index: AcfmQsVqZLnHJIG0RjSw3mPzpxn2qQ==
References: <46CE1BA2.8070200@gmail.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Luka Napotnik" <luka.napotnik@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Aug 2007, Luka Napotnik wrote:
> Hello.
>
> I'm new to kernel development and have some questions.
>
> 1. Why can't I divide with regular casting to double ((double)a /
> (double)b)? It gives me strange errors when compiling:
>
> WARNING: "__divdf3" [/root....] undefined!
> WARNING: "__addf3" [/root/...] undefined!
> WARNING: "__floatsidf" [/root/...] undefined!
>
> And if I compile with normal integers, I get zero as the result.
>
> 2. I'm trying to get the percentage of CPU used for a certain
> task_struct and figured the following formula:
>
> (task->utime + task->stime) / jiffies
>
> Before calculating I convert all the variables to jiffies. Is this correct?
>
> Please help.
>
> Greets,
> Lukla

Floating point operations are not allowed in the kernel. Often,
when you think you are simply creating a constant, the compiler
generates runtime code so you have to watch out for that as well.

You can use "long long" for high precision math if necessary.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.30 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
