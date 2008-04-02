Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbYDBOSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbYDBOSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbYDBORv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:17:51 -0400
Received: from mail.syneticon.net ([213.239.212.131]:35387 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756736AbYDBORu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:17:50 -0400
Message-ID: <47F39575.40006@wpkg.org>
Date: Wed, 02 Apr 2008 16:17:25 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
       ext-adrian.hunter@nokia.com, jwboyer@gmail.com, w@1wt.eu,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
References: <47F1EC20.6050600@wpkg.org> <47F1F644.4060000@yandex.ru> <47F202D9.20405@wpkg.org> <47F2071A.6010406@yandex.ru>
In-Reply-To: <47F2071A.6010406@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy schrieb:
> Tomasz Chmielewski wrote:

(...)

>> Performance is only one factor in the equation. Other factors are: 
>> cost and reliability.
>>
>> I speak from experience: flash-based block devices tend to have poor 
>> wear-levelling (at least Transcend IDE-flash disks).
>> To reproduce:
>> - format a 2 GB Transcend IDE-flash disk with ext3
>> - write a small file (50-100 kB)
>> - update that file ~several hundred thousand times - as you finish, 
>> IDE-flash disk will have 200-300 badblocks
> Yeah, that's bad. But if you have a bad FTL, surely there is not guarantee
> a flash FS will help? Isn't it better to use better hardware?
> 
> We did some experiments with MMC cards and we were unable to wear them
> out with re-writing the same sectors again and again. This suggests there
> _is_ better FTL hardware then that USB stick you was using.
> 
> Anyway, your original mail said Logfs can work with block devices. My 
> answer -
> UBIFS too, but this is very strange to do this IMO. But OK, it might is not
> senseless, sorry for the wording. :-)

I was thinking why my IDE-flash disk died so soon[1] and how efficient 
can an internal wear-levelling be in devices which hide its "flashiness" 
(USB-sticks, IDE-flash disks etc.).

Internal wear-levelling mechanism doesn't have a clue about free space 
on the filesystem - it that case, how can it do any efficient 
wear-levelling?



[1] Well, it didn't die, really. Once I removed the file which was 
showing I/O errors and did "dd if=/dev/zero of=bigfile", there are no 
badblocks anymore - probably remapped.



-- 
Tomasz Chmielewski
http://wpkg.org
