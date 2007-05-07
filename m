Return-Path: <linux-kernel-owner+w=401wt.eu-S966145AbXEGS2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966145AbXEGS2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934497AbXEGS2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:28:10 -0400
Received: from mail.parknet.jp ([210.171.160.80]:4529 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934490AbXEGS2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:28:08 -0400
X-AuthUser: hirofumi@parknet.jp
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: Long file names in VFAT broken with iocharset=utf8
References: <200705072151.20104.arvidjaar@mail.ru>
	<60F72760-C801-4F60-BF47-C661B4B5BE26@e18.physik.tu-muenchen.de>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 08 May 2007 03:27:53 +0900
In-Reply-To: <60F72760-C801-4F60-BF47-C661B4B5BE26@e18.physik.tu-muenchen.de> (Roland Kuhn's message of "Mon\, 7 May 2007 20\:07\:26 +0200")
Message-ID: <87fy685w0m.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de> writes:

>> This was posted in one of Russian forums. It was not possible to  
>> archive
>> (under Linux, using tar) vfat directory where files had long  
>> Russian names
>> (really long - over 150 - 170 characters) - tar returned stat  
>> failure. When
>> looking with plain ls, file names appeared truncated.
>>
>> Now looking at current (2.6.21) fat driver, __fat_readdir allocates  
>> large
>> enough buffer (PAGE_SIZE-522) for UTF-8 name; but for  
>> iocharset=utf8 it calls
>> uni16_to_x8() which artificially limits length of UTF-8 name to  
>> 256 ... which
>> is obviously not enough for long UTF-8 Russian string (2 bytes per  
>> character)
>> not to mention the - theoretical - general case of 6 bytes UTF-8  
>> characters.
>>
>> Similar problem has apparently vfat_lookup()->...->fat_search_long 
>> () call
>> chain. Except this appears to be broken even in case of "utf8",  
>> because
>> fat_search_long allocates fixed 256 bytes buffer for UTF-8 name.
>>
>> Am I off track here?
>>
> PATH_MAX specifically counts _bytes_ not characters, so UTF-8 does  
> not matter. ISTR that PATH_MAX was 256 at some point, but I just  
> quickly grepped /usr/include and found various mention of 4096, so  
> where's the central repository for this configuration item? A hard- 
> coded value of 256 somewhere inside the kernel smells like a bug.

There is a nasty issue here. FAT is limited by 255 unicode chars or so.
So, we would need to count number of unicode chars of filename.

That's not implemented currently.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
