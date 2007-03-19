Return-Path: <linux-kernel-owner+w=401wt.eu-S965211AbXCSDrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965211AbXCSDrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 23:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXCSDrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 23:47:11 -0400
Received: from mail.parknet.jp ([210.171.160.80]:1947 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965211AbXCSDrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 23:47:09 -0400
X-AuthUser: hirofumi@parknet.jp
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>
	<45FDFC69.6020605@ums.usu.ru>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 19 Mar 2007 12:46:56 +0900
In-Reply-To: <45FDFC69.6020605@ums.usu.ru> (Alexander E. Patrakov's message of "Mon\, 19 Mar 2007 07\:58\:49 +0500")
Message-ID: <87d535vqrz.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Alexander E. Patrakov" <patrakov@ums.usu.ru> writes:

>> You allow to set any nls to codepage? If so, it is not good.
>
> I did this because it involved less changes. Only FAT treats codepage as a 
> number. All other filesystems already allow arbitrary NLS as a codepage 
> mount parameter.

I'm saying here, it is not good for vfat.

>> No, utf-8 makes completely wrong entry. It's more wrong than other nls.
>
> For any non-UTF-8 based locales, the other NLS is correct and utf8 indeed 
> would produce completely wrong characters. But for UTF-8 based locales, utf8 
> is the only correct iocharset.

No, iocharset=utf8 is wrong always.

>>>  * Makes CONFIG_NLS_DEFAULT and CONFIG_CODEPAGE_DEFAULT adjustable at 
>>> runtime via the following mechanisms:
>> 
>> The configurable sounds sane, and it may help some case. But, it should
>> not be system global. At least, I think the default would be per-filesystem,
>> otherwise some configs seems to be needed for other filesystem after all.
>
> OK, now I see that your primary objection is to merging options, and 
> disagree (incorrect locale setup on your side is suspected). For meaningful 
> discussion, I want to see the following:
>
> 1) Output of "locale -a"
> 2) Output of "yes --help" from the same terminal
> 3) The correct iocharset and codepage for mounting FAT filesystems on USB 
> flash drives that are known readable under Windows (here "correct" = "ls in 
> this terminal shows filenames correctly").
> 4) The same for SMB filesystems.

Ah, ok. I'm thinking one locale is not enough, at least for now.
Why I can't use utf8 for jfs or something, and use other nls for vfat?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
