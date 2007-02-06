Return-Path: <linux-kernel-owner+w=401wt.eu-S1030187AbXBFWUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030187AbXBFWUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030188AbXBFWUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:20:53 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:1781 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030187AbXBFWUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:20:51 -0500
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Message-ID: <45C8FFEF.60806@amd.com>
Date: Tue, 06 Feb 2007 23:23:43 +0100
From: "Markus Rechberger" <markus.rechberger@amd.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070206)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] x86-64 ext2/ext3 datestamp problem
References: <45C8F419.5040103@amd.com> <45C8F7E6.6060009@zytor.com>
 <45C8F9DA.6040906@amd.com> <45C8FA62.7000308@zytor.com>
 <45C8FC19.1020109@amd.com> <45C8FC01.8060506@zytor.com>
In-Reply-To: <45C8FC01.8060506@zytor.com>
X-OriginalArrivalTime: 06 Feb 2007 22:20:37.0972 (UTC)
 FILETIME=[07537940:01C74A3D]
X-WSS-ID: 69D620B22KW7203223-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Markus Rechberger wrote:
>> H. Peter Anvin wrote:
>>> Markus Rechberger wrote:
>>>> My debian system's coreutils package only allows dates between 1902
>>>> and
>>>> 2038, but it might be interesting to get that right if it's wrong.
>>>>
>>>> touch (GNU coreutils) 5.97 just says invalid dateformat to 2050-01-01
>>> Lemme guess, you're on a 32-bit system...
>>>
>>
>> I have both here, 64 and 32bit
>> If I touch a file with 1905 on my 32bit system and remount the disk the
>> date will remain at 1905 without any patch.
>>
>
> The reason is that most 32-bit systems (e.g. i386) only have a 32-bit
> time_t, so the user space interface wraps around in 2038.
>
> However, most 64-bit systems (e.g. x86_64) have 64-bit time_t, and
> thus don't have that problem.
>
>     -hpa
>
>
I know time_t expands to long, anyway the existing filesystem layout

cannot be changed so that problem would even remain with a 64bit system
unless the whole system would really treat it as unsigned. A 64 bit
system will cast the unsigned stamp over a signed long value which in
this case is bigger than 32 bit and behaves differently.


-- 
Markus Rechberger
Operating System Research Center
AMD Saxony LLC & Co. KG



