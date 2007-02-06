Return-Path: <linux-kernel-owner+w=401wt.eu-S965556AbXBFVy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965556AbXBFVy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965557AbXBFVy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:54:58 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:11136 "EHLO
	outbound7-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965556AbXBFVyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:54:54 -0500
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Message-ID: <45C8F9DA.6040906@amd.com>
Date: Tue, 06 Feb 2007 22:57:46 +0100
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070206)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] x86-64 ext2/ext3 datestamp problem
References: <45C8F419.5040103@amd.com> <45C8F7E6.6060009@zytor.com>
In-Reply-To: <45C8F7E6.6060009@zytor.com>
X-OriginalArrivalTime: 06 Feb 2007 21:54:41.0806 (UTC)
 FILETIME=[67C762E0:01C74A39]
X-WSS-ID: 69D626AF2KW7200673-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Markus Rechberger wrote:
>> Hi,
>>
>> there is an issue with ext2/ext3 date stamps, if someone creates a file
>> with a timestamp between 1902 and 1970(epoch 0) it will overflow and
>> result in a higher date than 2038.
>>
>> $ touch --date "1905-01-01" test
>> $ ls -lah test
>> -rw-r--r-- 1 root root 0 Jan  1  1905 test (this is a cached value here)
>> (remount the partition/clear the cache)
>> $ ls -lah test
>> -rw-r--r-- 1 root root 0 Feb  6  2041 test
>>
>> 10000101101111001100011001110000 .. -2051226000 (1905)
>> 10000101101111001100011001110000 .. 2243741296 (2041)
>>
>> this was tested against linus git tree
>>
>
> I believe the timestamp fields in ext2/ext3 are defined as unsigned.
>
>     -hpa
>
>
My debian system's coreutils package only allows dates between 1902 and
2038, but it might be interesting to get that right if it's wrong.

touch (GNU coreutils) 5.97 just says invalid dateformat to 2050-01-01

Markus

-- 
Markus Rechberger
Operating System Research Center
AMD Saxony LLC & Co. KG



