Return-Path: <linux-kernel-owner+w=401wt.eu-S965506AbXBFWHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965506AbXBFWHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965532AbXBFWHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:07:14 -0500
Received: from terminus.zytor.com ([192.83.249.54]:49509 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965506AbXBFWHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:07:12 -0500
Message-ID: <45C8FC01.8060506@zytor.com>
Date: Tue, 06 Feb 2007 14:06:57 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Markus Rechberger <markus.rechberger@amd.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] x86-64 ext2/ext3 datestamp problem
References: <45C8F419.5040103@amd.com> <45C8F7E6.6060009@zytor.com> <45C8F9DA.6040906@amd.com> <45C8FA62.7000308@zytor.com> <45C8FC19.1020109@amd.com>
In-Reply-To: <45C8FC19.1020109@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger wrote:
> H. Peter Anvin wrote:
>> Markus Rechberger wrote:
>>> My debian system's coreutils package only allows dates between 1902 and
>>> 2038, but it might be interesting to get that right if it's wrong.
>>>
>>> touch (GNU coreutils) 5.97 just says invalid dateformat to 2050-01-01
>> Lemme guess, you're on a 32-bit system...
>>
> 
> I have both here, 64 and 32bit
> If I touch a file with 1905 on my 32bit system and remount the disk the
> date will remain at 1905 without any patch.
> 

The reason is that most 32-bit systems (e.g. i386) only have a 32-bit 
time_t, so the user space interface wraps around in 2038.

However, most 64-bit systems (e.g. x86_64) have 64-bit time_t, and thus 
don't have that problem.

	-hpa
