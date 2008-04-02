Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYDBEv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYDBEv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 00:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYDBEvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 00:51:51 -0400
Received: from smtp.nokia.com ([192.100.122.230]:20570 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbYDBEvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 00:51:50 -0400
Message-ID: <47F30FDD.5080003@yandex.ru>
Date: Wed, 02 Apr 2008 07:47:25 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru> <878wzx25s7.fsf@basil.nowhere.org> <47F21B47.4000206@yandex.ru> <47F26278.5070009@zytor.com> <20080401212652.GD23796@1wt.eu>
In-Reply-To: <20080401212652.GD23796@1wt.eu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Apr 2008 04:51:27.0875 (UTC) FILETIME=[360DB530:01C8947D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
>> Well, even auto-levelling storage should benefit from a filesystem which 
>> minimizes the total number of flash sectors churned, which means doing 
>> as few writes as possible and to large, contiguous sections.
> 
> Exactly. At exosec, we ship one appliance which writes statistics to a
> partition on a compactflash every 5 minutes. We preferred to go with JFFS2
> exactly because of this reason. We never had any problem proceeding this way.
> I'm not sure if it would have been the same with ext2 though.
>

Yes, as I agreed in a previous mail this may make sense in some cases.

But in general it is not a good approach. Basically, it is wastage of resources.
Indeed, first the firmware on MMC/SD/etc makes efforts to make flash look
like a block device. It gives you in-place updates, but by cost of performance
and reliability. Then you just drop this nice property, and use JFFS2, which
assumes it has only out-of-place updates. But if this solves the task you have
- fine!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
