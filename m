Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbYDKOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbYDKOeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 10:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbYDKOeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 10:34:14 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:1908 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774AbYDKOeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 10:34:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 11 Apr 2008 14:34:10.0358 (UTC) FILETIME=[1B08FD60:01C89BE1]
Content-class: urn:content-classes:message
Subject: Re: VM - a plenty of inactive memory
Date: Fri, 11 Apr 2008 10:34:10 -0400
Message-ID: <Pine.LNX.4.61.0804111024020.4784@chaos.analogic.com>
In-Reply-To: <cf40c6a90804110613v46de93f2nea1b2376bbd48953@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: VM - a plenty of inactive memory
thread-index: Acib4RsQuyNfC+e0T0yXhxe8Ce9V4Q==
References: <cf40c6a90804090213u55491ceay9b211d75d74dc29c@mail.gmail.com> <874pabrx6b.fsf@saeurebad.de> <cf40c6a90804110613v46de93f2nea1b2376bbd48953@mail.gmail.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Andreas Grimm" <agrimm61@gmail.com>
Cc: "Johannes Weiner" <hannes@saeurebad.de>, <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-TM-AS-Product-Ver: SMEX-8.0.0.1259-5.000.1023-15842.003
X-TM-AS-Result: No--13.031700-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 11 Apr 2008, Andreas Grimm wrote:

> Hi everybody,
>
> i investigated this further. The tunables swappiness, drop_caches etc.
> are no options to solve this. The problem is becoming very unpleasent,
> because the system isn't able to cache that much:
>
> The 16GB system (expected behaviour):
> MemTotal:     16619808 kB
> MemFree:       4490032 kB
> Cached:        6929448 kB
> Inactive:      1670812 kB
>
> The 32GB system :
> MemTotal:     33265916 kB
> MemFree:        600000 kB
> Cached:        1561124 kB
> Inactive:     25873128 kB
>
> Don't you think this is insane? Wasting 25GB at the expense of caching
> (compare the cached value)? I'm clueless about this issue. Who (which
> process) owns that memory? Is there a way to flush this inactive
> memory? I assume that this memory hasn't been reclaimed for days,
> because the amount of inactive memory is at this level for days now.
>
> All values in /proc/sys/vm are at the defaults again, on both systems.
>
> Any help would be appreciated.
>
> Andreas

Wasting 25GB? It looks to me as though the kernel cached
(didn't write pages to disk yet) just about all it needed,
and there is lots of memory that it just doesn't need
  --yet! This means that if you have tasks that need memory
in a hurry, they'll get it without any disk accesses.

The kernel doesn't expand to use all the memory just to
spread itself all over the place. It uses what it needs,
caches some buffered data, and keepts track of all the
memory it has. If you want to use more cache, do '-lsR /'.
That'll read every directory into memory. It probably
won't go away until someody needs more memory.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
