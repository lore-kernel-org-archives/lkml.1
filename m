Return-Path: <linux-kernel-owner+w=401wt.eu-S1762630AbYJJUYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762630AbYJJUYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 16:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761959AbYJJUYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 16:24:40 -0400
Received: from adelie.canonical.com ([91.189.90.139]:43675 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761647AbYJJUYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 16:24:40 -0400
Message-ID: <48EFB9F8.2060406@canonical.com>
Date: Fri, 10 Oct 2008 16:24:24 -0400
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: stable@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [stable] [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in	used_vectors
 bitmap
References: <48EFB4B2.2020508@canonical.com> <20081010201805.GC32164@kroah.com>
In-Reply-To: <20081010201805.GC32164@kroah.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Oct 10, 2008 at 04:01:54PM -0400, Stefan Bader wrote:
>> Affected: 2.6.24-2.6.27
>>
>> Someone from the community found out, that after repeatedly unloading and
>> loading a device driver that uses MSI IRQs, the system eventually assigned
>> the vector initially reserved for IRQ0 to the device driver.
>>
>> The reason for this is, that although IRQ0 is tied to the FIRST_DEVICE_VECTOR
>> when declaring the irq_vector table, the corresponding bit in the used_vectors
>> map is not set. So, if vectors are released and assigned often enough, the
>> vector will get assigned to another interrupt. This happens more often with
>> MSI interrupts as those are exclusively using a vector.
> 
> Is there a problem with being assigned to IRQ0 in situations like this?
> 
> thanks,
> 
> greg k-h
Yes, since IRQ0 is still wanted and used by the system timer. After the module
get unloaded again, the vector gets freed and no timer interrupt is delivered
anymore.

Stefan

-- 

When all other means of communication fail, try words!


