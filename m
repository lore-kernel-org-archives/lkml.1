Return-Path: <linux-kernel-owner+w=401wt.eu-S1760176AbYJISJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176AbYJISJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYJISJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:09:34 -0400
Received: from smtp02.mtu.ru ([62.5.255.49]:54883 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbYJISJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:09:34 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: loading ipmi_watchdog causes tons of other watchdog modules to be loaded
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 09 Oct 2008 22:09:14 +0400
References: <200810091348.19828.a.miskiewicz@gmail.com> <ac3eb2510810090636w51e04a7fxfa36d8b016b236d@mail.gmail.com> <200810091922.24108.a.miskiewicz@gmail.com>
User-Agent: KNode/0.10.9
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <20081009180920.05888143D6F1@smtp02.mtu.ru>
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arkadiusz Miskiewicz wrote:

> On Thursday 09 October 2008, Kay Sievers wrote:
>> On Thu, Oct 9, 2008 at 1:48 PM, Arkadiusz Miskiewicz
>>
>> <a.miskiewicz@gmail.com> wrote:
>> > No udev on the system. kernel 2.6.25.18-1.
>> >
>> > After loading ipmi_watchdog and doing "cat /dev/watchdog" tons of
>> > other, useles, watchdog modules is loaded. Any idea what introduced
>> > such weird behaviour?
>>
>> I guess the /proc/sys/kernel/modprobe, which lets the kernel fork a
>> modprobe process when you touch a "dangling" device node, which does
>> not have corresponding driver.
> 
> ... but that ipmi_watchdog is the correct driver that handles
> /dev/watchdog, so this shouldn't be happening, correct?
> 

That's true, but it declares itself as handler for this device entry very
deep in some callback. It is quite possible that event that would have
triggered this callback did not yet happen. 

