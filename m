Return-Path: <linux-kernel-owner+w=401wt.eu-S1750880AbXCSO0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750880AbXCSO0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 10:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbXCSO0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 10:26:09 -0400
Received: from mail.parknet.jp ([210.171.160.80]:2115 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbXCSO0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 10:26:08 -0400
X-AuthUser: hirofumi@parknet.jp
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>
	<45FDFC69.6020605@ums.usu.ru> <87d535vqrz.fsf@duaron.myhome.or.jp>
	<45FE13B9.8000203@ums.usu.ru> <87vegxdc8i.fsf@duaron.myhome.or.jp>
	<45FE2483.4060706@ums.usu.ru>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 19 Mar 2007 23:25:54 +0900
In-Reply-To: <45FE2483.4060706@ums.usu.ru> (Alexander E. Patrakov's message of "Mon\, 19 Mar 2007 10\:49\:55 +0500")
Message-ID: <878xdtux71.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Alexander E. Patrakov" <patrakov@ums.usu.ru> writes:

> OGAWA Hirofumi wrote:
>
>> I don't care about "read", because it doesn't corrupt filesystem. I care
>> about only "write", because it can corrupt filesystem.
>> 
>> If it's read-only, I'll not care at all, and will agree.
>
> Here you are right, but please tell RedHat about this (and you'll be at 
> least called an old-fashioned person). They (and from their initiative, 
> almost everyone else) use UTF-8 based locales by default, and ONLY utf8 NLS 
> gives correct characters in filenames in this case.
>
> Besides, FS corruption is possible only if the user intentionally writes two 
> files with names differing only in their case.

No, the utf8 support of vfat is wrong. This is implementation
thing, and it is not recommended until it is fixed.

>> All are user policy. The users can switch locale and
>> G_FILENAME_ENCODING and something else, some app can switch it even
>> runtime, and I think kernel shouldn't have user policy, right?
>
> G_FILENAME_ENCODING is a Glib2-only heresy, please ignore it. The "ls" tool 
> always assumes that file names are in the same encoding as the output of 
> "locale charmap" command. The fact that the filenames (contrary to what 
> Glib2 developers say) should be in the locale encoding becomes very obvious 
> if one reads POSIX specifications for tar and cpio programs (otherwise, they 
> won't talk about conversion errors).

I'm talking about two filesystems on a system here, not two encoding
on one filesystem. You can change locale on each filesystems, or each
directory, of course if it's not vfat.

It's wrong? May or may not be true. It's the user policy.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
