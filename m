Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbXLGQaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbXLGQaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 11:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbXLGQaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 11:30:13 -0500
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:49977 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbXLGQaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 11:30:11 -0500
Message-ID: <475974F8.9040603@linux.vnet.ibm.com>
Date: Fri, 07 Dec 2007 17:29:44 +0100
From: Holger Wolf <wolf@linux.vnet.ibm.com>
Reply-To: Holger.Wolf@de.ibm.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Holger.Wolf@de.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Scheduler behaviour
References: <475706E2.50805@linux.vnet.ibm.com> <20071205132631.79940bd5@laptopd505.fenrus.org>
In-Reply-To: <20071205132631.79940bd5@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Wed, 05 Dec 2007 21:15:30 +0100
> Holger Wolf <wolf@linux.vnet.ibm.com> wrote:
>
>   
>> We discovered performance degradation with dbench when using kernel
>> 2.6.23 compared to kernel 2.6.22.
>>
>> In our case we booted a Linux in a IBM System z9 LPAR with 256MB of
>> ram with 4 CPU's. This system uses a striped LV with 16 disks on a
>> Storage Server connected via 8 4GBit links.
>> A dbench was started on that system performing I/O operations on the
>> striped LV. dbench runs were performed with 1 to 62 processes.
>> Measurements with a 2.6.22 kernel were compared to measurements with
>> a 2.6.23 kernel. We saw a throughput degradation from 7.2 to 23.4
>>     
>
> this is good news!
> dbench rewards unfair behavior... so higher dbench usually means a
> worse kernel ;)
>
>
>   
tests with 2.6.22 including CFS  show the same results.
This means the pressure on page cache is much higher when all processes 
run in parallel.
We see this behavior as well with iozone when writing on many disks with 
many threads and just 256 MB memory.

This means the scheduler schedules as it should - fair.

regards Holger

