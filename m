Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbZLVR6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbZLVR6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:58:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZLVR6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:58:12 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:38170 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZLVR6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:58:12 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jean-Pierre =?iso-8859-1?Q?Andr=E9?= 
	<jean-pierre.andre@wanadoo.fr>
Cc: Eric Blake <ebb9@byu.net>, fuse-devel@lists.sourceforge.net,
       Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr>
	<874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr>
	<87ljgvi1an.fsf@devron.myhome.or.jp> <4B30F0C9.2020702@wanadoo.fr>
Date: Wed, 23 Dec 2009 02:58:03 +0900
In-Reply-To: <4B30F0C9.2020702@wanadoo.fr> ("Jean-Pierre =?iso-8859-1?Q?An?=
 =?iso-8859-1?Q?dr=E9=22's?= message of
	"Tue, 22 Dec 2009 17:16:09 +0100")
Message-ID: <87my1aevro.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean-Pierre André <jean-pierre.andre@wanadoo.fr> writes:

> Hi again,

Hi,

>> Yes.  AFAIK, fuse of kernel part is passing FATTR_MTIME without
>> FATTR_ATIME to userland (i.e. FUSE_SET_ATTR_ATIME and
>> FUSE_SET_ATTR_MTIME in libfuse).
>>
>> I think it's good to implement if it's not design decision of ntfs-3g.
>>
>> [BTW, just my guess though, it would be good to use "if (vaild&
>> ATTR_XXX)" style, not "switch()" to support various combinations of
>> flags]
>>    
>
> Might be better, ... or not. Setting both mtime
> and atime is much simpler than setting each one
> individually. So both methods will end up having
> to process three different situations.

Well, I don't care the implementation detail. However, the combination
might not be only three. E.g. if fs was exported as network fs's
backend, so many combinations are possible. So, specified known
combination can be fragile.

(e.g. ATTR_MTIME | ATTR_SIZE, etc, etc.)

> I suggest I port Miklos patch to fuse-lite soon,
> and delay the low-level case (and microsecond
> precision) until January. Does that suit your needs ?

Thanks. Sounds good. I'm not using ntfs-3g actually, I just bridged the
bug report on lkml to others. Eric?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
