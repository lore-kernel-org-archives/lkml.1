Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbZKAWeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbZKAWeI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 17:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbZKAWeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 17:34:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbZKAWeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 17:34:07 -0500
Message-ID: <4AEE0CAA.4070403@zytor.com>
Date: Mon, 02 Nov 2009 07:33:14 +0900
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Doug Thompson <norsk5@yahoo.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86 <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] amd64_edac: syndromes loading
References: <20091028163534.GA625@aftab> <143841.81095.qm@web50110.mail.re2.yahoo.com> <20091028172853.GE625@aftab> <20091101211305.GB2085@ucw.cz>
In-Reply-To: <20091101211305.GB2085@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 06:13 AM, Pavel Machek wrote:
>>
>> Alternatively, we could make the syndromes builtin thus removing the
>> requirement to go to userspace for the loading. For that we'll need
>> two new .c files in drivers/edac/ which represent the x4 and x8 tables
>> respectively:
>>
>> unsigned short x8_raw_data[] = {
>>          0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
>>          0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000, 0x0000,
>>          0x0000, 0x0100, 0x0001, 0x0101, 0x01B8, 0x015C, 0x012E, 0x01C6, 0x0163,
>>          0x01FD, 0x0189, 0x019D, 0xB801, 0x5C01, 0x2E01, 0xC601, 0x6301, 0xFD01,
>>          0x8901, 0x9D01, 0x0200, 0x0002, 0x0202, 0x0201, 0x02B8, 0x025C, 0x02FD,
>> 	....
>>
>> The drawback with these is that they'll always be builtin, enlarging
>> kernel code by 10-15K although only one of them is in use.
>
> I believe that 15K is reasonable price to pay for not having to
> install another 'firmware' file.
> 								Pavel

a) aren't these computable somehow?  If so, it's probably easier to 
include the algorithm in the kernel rather than a table.

b) "I believe that 15K is reasonable price to pay for not having to 
install another 'firmware' file."  I think that's a tradeoff a lot of 
people would *not* choose to make.  This is of course why we have (or at 
least, should have) to either compile in firmware blobs or not.

	-hpa
