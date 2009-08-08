Return-Path: <linux-kernel-owner+w=401wt.eu-S934007AbZHHKSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007AbZHHKSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 06:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933977AbZHHKSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 06:18:03 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40043 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933950AbZHHKSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 06:18:03 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Roel Kluin <roel.kluin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fat: Read buffer overflow
References: <4A7CAF28.8020908@gmail.com> <87y6pvi5qp.fsf@devron.myhome.or.jp>
	<84144f020908072356r5cc3100dp79a6a508bafec7c7@mail.gmail.com>
	<87prb6pqdu.fsf@devron.myhome.or.jp>
Date: Sat, 08 Aug 2009 19:18:01 +0900
In-Reply-To: <87prb6pqdu.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Sat, 08 Aug 2009 19:10:53 +0900")
Message-ID: <877hxeobhi.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> Pekka Enberg <penberg@cs.helsinki.fi> writes:
>
>> Yes, but we pass "ulen" to vfat_is_used_badchars(). The value of
>> "ulen" is a returned in the "longlen" argument of xlate_to_uni() which
>> in turn is calculated as follows for the UTF-8 case:
>>
>>   int name_len = strlen(name);
>>   *outlen = utf8s_to_utf16s(name, PATH_MAX, (wchar_t *) outname);
>>   *outlen -= (name_len - len);
>>   *longlen = *outlen;
>>
>> Maybe "*outlen" can never be negative because of some invariants that
>> I don't see but it's so non-obvious to me that I'd like to see the
>> explicit check in vfat_is_used_badchars().
>
> Ah, good point. Sorry, I was looking my tree. I'm going to submit the
> attached patch on next merge window.
>
> Is this enough for it?

BTW, if we want the sanity check of "longlen", I'd like to put it in the
end of xlate_to_uni(), not vfat_is_used_badchars(). Because I think it's
job of xlate_to_uni().

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
