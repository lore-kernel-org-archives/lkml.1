Return-Path: <linux-kernel-owner+w=401wt.eu-S1760587AbYJIS7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760587AbYJIS7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbYJIS6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:58:50 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:20018 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbYJIS6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:58:49 -0400
Message-ID: <ac3eb2510810091158x3b677959j480c554b86c1ee26@mail.gmail.com>
Date: Thu, 9 Oct 2008 20:58:44 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Arkadiusz Miskiewicz" <a.miskiewicz@gmail.com>
Subject: Re: loading ipmi_watchdog causes tons of other watchdog modules to be loaded
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200810091922.24108.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810091348.19828.a.miskiewicz@gmail.com>
	 <ac3eb2510810090636w51e04a7fxfa36d8b016b236d@mail.gmail.com>
	 <200810091922.24108.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 7:22 PM, Arkadiusz Miskiewicz
<a.miskiewicz@gmail.com> wrote:
> On Thursday 09 October 2008, Kay Sievers wrote:
>> On Thu, Oct 9, 2008 at 1:48 PM, Arkadiusz Miskiewicz
>>
>> <a.miskiewicz@gmail.com> wrote:
>> > No udev on the system. kernel 2.6.25.18-1.
>> >
>> > After loading ipmi_watchdog and doing "cat /dev/watchdog" tons of other,
>> > useles, watchdog modules is loaded. Any idea what introduced such weird
>> > behaviour?
>>
>> I guess the /proc/sys/kernel/modprobe, which lets the kernel fork a
>> modprobe process when you touch a "dangling" device node, which does
>> not have corresponding driver.
>
> ... but that ipmi_watchdog is the correct driver that handles /dev/watchdog,
> so this shouldn't be happening, correct?

While the driver you expect to work is loaded, what does:
  ls -l /dev/watchdog
print?

If the devno of this node is 10:130, what does:
  find /sys/class /sys/devices/ -name dev | xargs grep 10:130
print?

Kay
