Return-Path: <linux-kernel-owner+w=401wt.eu-S965267AbXCSFi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965267AbXCSFi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 01:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965524AbXCSFi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 01:38:29 -0400
Received: from mail.parknet.jp ([210.171.160.80]:1988 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965267AbXCSFi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 01:38:28 -0400
X-AuthUser: hirofumi@parknet.jp
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
References: <45FD6EF5.1030706@ums.usu.ru> <87hcsius7b.fsf@duaron.myhome.or.jp>
	<45FDFC69.6020605@ums.usu.ru> <87d535vqrz.fsf@duaron.myhome.or.jp>
	<45FE13B9.8000203@ums.usu.ru>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 19 Mar 2007 14:38:21 +0900
In-Reply-To: <45FE13B9.8000203@ums.usu.ru> (Alexander E. Patrakov's message of "Mon\, 19 Mar 2007 09\:38\:17 +0500")
Message-ID: <87vegxdc8i.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Alexander E. Patrakov" <patrakov@ums.usu.ru> writes:

> OGAWA Hirofumi wrote:
>> "Alexander E. Patrakov" <patrakov@ums.usu.ru> writes:
>> 
>>>> You allow to set any nls to codepage? If so, it is not good.
>>> I did this because it involved less changes. Only FAT treats codepage as a 
>>> number. All other filesystems already allow arbitrary NLS as a codepage 
>>> mount parameter.
>> 
>> I'm saying here, it is not good for vfat.
>
> All valid options (i.e. numbers) are still available. Prohibiting 
> non-numbers is a lot of work (changing module_param_string to 
> module_param_call and validating the passed string, and also changing the 
> code for all filesystems so that they also validate manually-passed codepage 
> string).

Ok.

>>>> No, utf-8 makes completely wrong entry. It's more wrong than other nls.
>>> For any non-UTF-8 based locales, the other NLS is correct and utf8 indeed 
>>> would produce completely wrong characters. But for UTF-8 based locales, utf8 
>>> is the only correct iocharset.
>> 
>> No, iocharset=utf8 is wrong always.
>
> Here we just disagree, but I think I can change your opinion by giving you a 
> correctly configured UTF-8 Japanese system in the form of a LiveCD (note: 
> the kernel doesn't have this patch there). If you can afford ~500 MB of 
> downloads, please do this:

I don't care about "read", because it doesn't corrupt filesystem. I care
about only "write", because it can corrupt filesystem.

If it's read-only, I'll not care at all, and will agree.

>> Why I can't use utf8 for jfs or something, and use other nls for vfat?
>
> Because you'll get a mismatch between the userspace locale and the iocharset 
> used by the kernel in at least one of these two cases. The mismatch will 
> result in the following:
>
> 1) Your system (e.g., the "ls" command) will not correctly interpret 
> filenames written by known-good setups.
> 2) Known-good setups will not correctly interpret filenames written by your 
> system.
>
> What probably happened in your case is that you have no known-good jfs-based 
> setup and are the only user of your jfs disk, and thus can't see (2). It 
> looks like you don't use UTF-8 userspace locale. Then, the on-disk filenames 
> on your jfs filesystem are wrong, but your system misinterprets them, and 
> two errors seem to cancel each other (but this still doesn't make it a 
> correct setup).

All are user policy. The users can switch locale and
G_FILENAME_ENCODING and something else, some app can switch it even
runtime, and I think kernel shouldn't have user policy, right?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
