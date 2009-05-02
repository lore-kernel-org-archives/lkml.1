Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZEBLD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZEBLD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 07:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbZEBLDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 07:03:15 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57535 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbZEBLDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 07:03:13 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: tridge@samba.org
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Add CONFIG_VFAT_NO_CREATE_WITH_LONGNAMES option
References: <1241199689.13073.6.camel@norville.austin.ibm.com>
	<87fxfnbytu.fsf@devron.myhome.or.jp>
	<87ws8zak1m.fsf@devron.myhome.or.jp>
	<87bpqbaji9.fsf@devron.myhome.or.jp>
	<18940.9039.850580.48730@samba.org>
Date: Sat, 02 May 2009 20:03:10 +0900
In-Reply-To: <18940.9039.850580.48730@samba.org> (tridge@samba.org's message
	of "Sat, 2 May 2009 20:41:19 +1000")
Message-ID: <87ab5v9381.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org writes:

> OGAWA Hirofumi writes:
>  > Um.., probably, this patch would be handle the invalid chars for 8.3 alias.
>  > Otherwise, it'll try to create ~<num> postfix, and I guess it'll become
>  > the dcache problem.
>
> Do you think that will cause problems? 

Yes. E.g. "test=.txt" will replace with "test_.txt" or such. But, dcache
still has "test=.txt". It means "test=.txt" would disappear with memory
pressure.

> If it will, then we could add something like this after the
> vfat_create_shortname() call:
>
> 	if (strncasecmp(name, msdos_name, MSDOS_NAME) != 0) {
> 		err = -EINVAL;
> 		goto out_free;
> 	}
>
> or would the potential case change still be a problem?

It may be ok. However, of course, it should consider other than
ascii. Well, I think the patch should be allow only perfect 8.3 name in
vfat_create_shortname(). (i.e. is_shortname && base/ext_info.valid)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
