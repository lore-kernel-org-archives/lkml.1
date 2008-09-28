Return-Path: <linux-kernel-owner+w=401wt.eu-S1753047AbYI1POB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbYI1POB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYI1PNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:13:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43228 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbYI1PNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:13:52 -0400
Message-ID: <48DF9EDA.1060809@zytor.com>
Date: Sun, 28 Sep 2008 08:12:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@newmail.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Ghost EDD devices in /sys again
References: <200809062208.m86M8hJM016685@terminus.zytor.com> <200809281035.06547.arvidjaar@newmail.ru>
In-Reply-To: <200809281035.06547.arvidjaar@newmail.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> On Sunday 07 September 2008, H. Peter Anvin wrote:
>> I think this is closer to what we really want; after all, memory being written is the "first principles" test that applies here.
>>
> 
> OK I have been using this for some time. I do not actually insist on
> returning "failure" for zero signature; my main concern was duplicated
> signature resulted from not clearing read buffer. Still I assume that
> zero signature is the same as no signature; i.e. even if disk is physically
> present but zeroed out there is no point in presenting mbr_signature in
> sysfs either.
> 

Right, I think that's a much better patch.

The really Right Thing[TM] to do is probably to pre-clear the buffer and 
then look for the 0xaa55 signature at offset 510; it is required for 
sector 0 to be a valid MBR-format partition table and hence for the MBR 
*signature* to be valid.

I'll write that up tomorrow (I'm travelling today), or you can send me a 
patch.

	-hpa

