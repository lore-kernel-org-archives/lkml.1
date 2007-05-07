Return-Path: <linux-kernel-owner+w=401wt.eu-S966918AbXEGVBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966918AbXEGVBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966639AbXEGVBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:01:17 -0400
Received: from mail.parknet.jp ([210.171.160.80]:4623 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966911AbXEGVBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:01:15 -0400
X-AuthUser: hirofumi@parknet.jp
To: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org
Subject: Re: Long file names in VFAT broken with iocharset=utf8
References: <200705072151.20104.arvidjaar@mail.ru>
	<60F72760-C801-4F60-BF47-C661B4B5BE26@e18.physik.tu-muenchen.de>
	<87fy685w0m.fsf@duaron.myhome.or.jp>
	<BD281C0E-5278-4944-ABF0-AF692325945C@e18.physik.tu-muenchen.de>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 08 May 2007 06:01:07 +0900
In-Reply-To: <BD281C0E-5278-4944-ABF0-AF692325945C@e18.physik.tu-muenchen.de> (Roland Kuhn's message of "Mon\, 7 May 2007 21\:59\:15 +0200")
Message-ID: <877irk5ox8.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de> writes:

>> Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de> writes:
>>> PATH_MAX specifically counts _bytes_ not characters, so UTF-8 does
>>> not matter. ISTR that PATH_MAX was 256 at some point, but I just
>>> quickly grepped /usr/include and found various mention of 4096, so
>>> where's the central repository for this configuration item? A hard-
>>> coded value of 256 somewhere inside the kernel smells like a bug.
>>
>> There is a nasty issue here. FAT is limited by 255 unicode chars or  
>> so.
>> So, we would need to count number of unicode chars of filename.
>>
> No, we don't. At least not when looking at the POSIX spec, which  
> explicitly mentions _bytes_ and _not_ unicode characters. So, to be  
> on the safe side, FAT filesystems would need to support a NAME_MAX of  
> roughly 6*255+3=1533 bytes (not to mention the hassles of forbidden  
> sequences, etc.; do we need to count zero-width characters?) and  
> report it through pathconf() to userspace, then userspace could do  
> with that whatever it liked.
>
> What happened to: "file names are just sequences of octets, excluding  
> '/' and UL"? Adding unicode parsing to the kernel is completely  
> useless _and_ a big trouble maker.

The UCS2 in FAT is just on-disk format of the filename. So...
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
